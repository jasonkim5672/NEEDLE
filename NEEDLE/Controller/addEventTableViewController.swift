//
//  addEventTableViewController.swift
//  NEEDLE
//
//  Created by Jason Kim on 2017. 12. 17..
//  Copyright © 2017년 JasonKim. All rights reserved.
//

import UIKit
import Firebase

class addEventTableViewController: UITableViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField! {
        didSet {
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
            nameTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
            
        } }
    @IBOutlet var periodTextField: UITextField! {
        didSet {
            periodTextField.tag = 2
            periodTextField.delegate = self
            periodTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        } }
    @IBOutlet var locationTextField: UITextField! {
        didSet {
            locationTextField.tag = 3
            locationTextField.delegate = self
            locationTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        } }
    @IBOutlet var peopleTextField: UITextField! {
        didSet {
            peopleTextField.tag = 4
            peopleTextField.delegate = self
            peopleTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        } }
    @IBOutlet var bodyTextView: UITextView! {
        didSet {
            bodyTextView.tag = 5
            bodyTextView.layer.cornerRadius = 5.0
            bodyTextView.layer.masksToBounds = true
            
        } }
    
    @IBAction func addEventButtonTapped(segue: UIStoryboardSegue){
        self.view.endEditing(true)
        
        if(self.nameTextField.text!.isEmpty || self.periodTextField.text!.isEmpty||self.locationTextField.text!.isEmpty||self.peopleTextField.text!.isEmpty||self.bodyTextView.text!.isEmpty){
            let alert = UIAlertController(title: "Oops", message: "모든 항목을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil ))
            self.present(alert, animated: true, completion: nil)
            
        }else if(self.photoImageView.image == nil){
            let alert = UIAlertController(title: "Oops", message: "사진을 넣어주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil ))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            let rootRef = Database.database().reference()
            
            if let user = Auth.auth().currentUser {
                rootRef.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (userData) in
                    // Get user value
                    let value = userData.value as? NSDictionary
                    let username = value?["username"] as? String ?? ""
                    let key = rootRef.child("posts").childByAutoId().key
                    let todaysDate:Date = Date()
                    let dateFormatter:DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                    let DateInFormat:String = dateFormatter.string(from:todaysDate)
                    
                    var data = Data()
                    data = UIImageJPEGRepresentation(self.photoImageView.image!, 0.8)!
                    // set upload path
                    let filePath = "event/\(user.uid)/\(key)/thumbnailImage"
                    let metaData = StorageMetadata()
                    
                    metaData.contentType = "image/jpg"
                    storage.reference().child(filePath).putData(data, metadata: metaData){(metaData,error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }else{
                            //store downloadURL
                            let downloadURL = metaData!.downloadURL()!.absoluteString
                            //store downloadURL at database
                            let childUpdates = ["/posts/\(key)/thumbnailImage": downloadURL,
                                                "/user-posts/\(user.uid)/\(key)/thumbnailImage": downloadURL]
                            rootRef.updateChildValues(childUpdates)

                            print("image upload success")
                        }
                        
                    }
                  
                    
                    let post = ["uid": user.uid,
                                "author": username,
                                "period" : self.periodTextField.text!,
                                "registerTime" : DateInFormat,
                                "location" : self.locationTextField.text!,
                                "people" : self.peopleTextField.text!,
                                "title": self.nameTextField.text!,
                                "body": self.bodyTextView.text!,
                                "tag": ""]
                  //  NDEvents.append(Event.init(title: self.nameTextField.text! ,author : username, uid : user.uid , location: self.locationTextField.text! , period : self.periodTextField.text!,registerTime: DateInFormat,body :self.bodyTextView.text! ,tag : "",people : self.peopleTextField.text!))
                    let childUpdates = ["/posts/\(key)": post,
                                        "/user-posts/\(user.uid)/\(key)/": post]
                    rootRef.updateChildValues(childUpdates)
                    
                    rootRef.child("/chats/room/\(self.nameTextField.text!)").setValue(["type":"1", "name":self.nameTextField.text!, "sub":"새로운 대화를 시작합니다.", "user": [(user.uid)] ])
 
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                let alert = UIAlertController(title: "WoW", message: "성공적으로 등록되었습니다.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "Default action"), style: .`default`, handler: {(alert: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)} ))
                self.present(alert, animated: true, completion: nil)
                

            }
           
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var colors = [UIColor]()
        colors.append(UIColor(red: 136, green: 128, blue: 216))
        colors.append(UIColor(red: 91, green: 143, blue: 191))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                    
                }
            })
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil) }
            })
            
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            present(photoSourceRequestController, animated: true, completion: nil) }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: .top,
                                               relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        dismiss(animated: true, completion: nil) }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder() }
        return true }
    
    
    
    
}
