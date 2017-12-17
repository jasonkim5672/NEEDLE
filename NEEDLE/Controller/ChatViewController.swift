//
//  ViewController.swift
//  ChatApp
//
//  Created by Reinder de Vries on 11/06/2017.
//  Copyright © 2017 LearnAppMaking. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}

class ChatViewController: JSQMessagesViewController
{
    /// This array will store all the messages shown on screen
    var messages = [JSQMessage]()
    
    /// Lazy computed property for painting outgoing messages blue
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    /// Lazy computed property for painting incoming messages gray
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        // First, check the defaults if an ID and display name are set
        if  let id = defaults.string(forKey: "jsq_id"),
            let name = defaults.string(forKey: "jsq_name")
        {
            // Set the JSQMVC properties for sender ID and display name
            senderId = id
            senderDisplayName = name
        }
        else
        {
            // If the defaults doesn't have the ID and name, generate an ID, set the name to blank, and show the name dialog
            senderId = String(arc4random_uniform(999999))
            senderDisplayName = ""
            
            // Save the sender ID
            defaults.set(senderId, forKey: "jsq_id")
            defaults.synchronize()
            
            // Show the display name dialog
            showDisplayNameDialog()
        }
        
        // Set the navigation bar title
        // 대화중인 상대 설정
        title = "\(senderDisplayName!)"
        
        // Add a tap gesture to the navigation bar, to bring up the name dialog when tapping
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDisplayNameDialog))
        tapGesture.numberOfTapsRequired = 1
        
        //navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        navigationController?.navigationBar.tintColor = .white
        
        // Remove the message bubble avatars, and the attachment button
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // Prepare the Firebase query: all latest chat data limited to 10 items
        let query = Constants.refs.databaseChats.queryLimited(toLast: 10)
        
        // Observe the query for changes, and if a child is added, call the snapshot closure
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            // Get all the data from the snapshot
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                !text.isEmpty   // <-- check if the text length > 0
            {
                // Create a new JSQMessage object with the ID, display name and text
                if let message = JSQMessage(senderId: id, displayName: name, text: text)
                {
                    // Append to the local messages array
                    self?.messages.append(message)
                    
                    // Tell JSQMVC that we're done adding this message and that it should reload the view
                    self?.finishReceivingMessage()
                }
            }
        })
    }
    
    /**
     Show a dialog that asks the user to input a display name,
     and store that display name in the user defaults.
     */
    @objc func showDisplayNameDialog()
    {
        // Grab the user defaults
        let defaults = UserDefaults.standard
        
        // Prepare the alert controller
        let alert = UIAlertController(title: "Your Display Name", message: "Before you can chat, please choose a display name. Others will see this name when you send chat messages. You can change your display name again by tapping the navigation bar.", preferredStyle: .alert)
        
        // Add a text field to the dialog
        alert.addTextField { textField in
            
            // If a display name is present in the user defaults, pre-fill the text field with that name
            if let name = defaults.string(forKey: "jsq_name")
            {
                textField.text = name
            }
            else
            {
                // Otherwise, pre-fill with a random name from the `names` array
                let names = ["Ford", "Arthur", "Zaphod", "Trillian", "Slartibartfast", "Humma Kavula", "Deep Thought"]
                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))]
            }
        }
        
        // Add an action (a button) to the alert controller, and call the closure when the button is tapped
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] _ in
            
            // Quick Note: in this closure `alert` references the alert controller
            
            // Check if the text field exists, and if its text isn't empty
            if let textField = alert?.textFields?[0], !textField.text!.isEmpty {
                
                // Set the JSQMVC display name
                self?.senderDisplayName = textField.text
                
                // Update the title
                // 제목바꾸기
                self?.title = "\(self!.senderDisplayName!)"
                
                // Update and save the user defaults
                defaults.set(textField.text, forKey: "jsq_name")
                defaults.synchronize()
            }
        }))
        
        // Present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        // Return a specific message by index path
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        // Return the number of messages
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        // Return the right image bubble (see top): outgoing/blue for messages from the current user, and incoming/gray for other's messages
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        // No avatar!
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        // Return an attributed string with the name of the user who's text bubble is shown, displayed on top of the bubble, or return `nil` for the current user
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        // Return the height of the bubble top label
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        // Get a reference for a new object on the `databaseChats` reference
        // `childByAutoId()` generates a unique random object key
        let ref = Constants.refs.databaseChats.childByAutoId()
        
        // Create the message data, as a dictionary
        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]
        
        // Save the data on the new reference
        ref.setValue(message)
        
        // Tell JSQMVC we're done here
        // Note: the UI and bubbles don't update until the newly sent message is returned via the .observe(.childAdded,with:) closure. Neat!
        finishSendingMessage()
    }
}


