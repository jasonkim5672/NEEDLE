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
        //채팅방 아이디 찾아서 들어가도록 바꿀것!
        static var databaseChats = databaseRoot.child("chats/talk/1")
    }
}

class ChatViewController: JSQMessagesViewController
{
    var myChat = ChatRoom()
    /// This array will store all the messages shown on screen
    var messages = [JSQMessage]()
    
    //메세지 전송색상
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    //메세지 도착색상
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        Constants.refs.databaseChats = Constants.refs.databaseRoot.child("chats/talk/"+myChat.uid)
        let defaults = UserDefaults.standard
        
        // First, check the defaults if an ID and display name are set
        senderId = chatUserId
        senderDisplayName = chatUserName
        
        defaults.set(senderId, forKey: "jsq_id")
        defaults.set(senderDisplayName, forKey: "jsq_name")
        
        defaults.synchronize()
        
        // Set the navigation bar title
        // 대화중인 상대 설정
        title = "\(myChat.name)"
        
        //navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        
        navigationController?.navigationBar.tintColor = .white
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let query = Constants.refs.databaseChats.queryLimited(toLast: 30)
        
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = self.messages[indexPath.item]
        
        var isOutgoing = false
        
        if message.senderId == self.senderId {
            isOutgoing = true
        }
        
        if isOutgoing {
            cell.textView.textColor = UIColor.white
        } else {
            cell.textView.textColor = UIColor.black
        }
        
        return cell
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


