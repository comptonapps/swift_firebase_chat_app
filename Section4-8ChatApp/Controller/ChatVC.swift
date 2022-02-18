//
//  ChatVC.swift
//  Section4-8ChatApp
//
//  Created by Jonathan Compton on 7/5/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import Firebase
import Flurry_iOS_SDK


class ChatVC: UIViewController, UITextFieldDelegate {
    
    var selectedUserArray = [String]()
    var messages = [UserMessage]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var ref : DatabaseReference!
    var handle : DatabaseHandle!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let logOutButtonTitle = NSLocalizedString("logOutButton", comment: "Title for log out bar button")
        let barButton = UIBarButtonItem(title: logOutButtonTitle, style: .plain, target: self, action: #selector(logOutTapped))
        navigationItem.rightBarButtonItem = barButton
        messageTextField.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messages.removeAll()
        //listen for textField change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        handle = ref.child("chats").observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? [String : AnyObject] {
                let senderID = value["senderID"] as! String
                if self.selectedUserArray.contains(senderID) || senderID == AuthenticationManager.sharedInstance.userId!{
                    let body = value["body"] as! String
                    let senderName = value["senderName"] as! String
                    let time = value["time"] as! Double
                    let message = UserMessage(senderID: senderID, time: time, body: body, senderName: senderName)
                    self.messages.append(message)
                }
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    //make sure tableView is at bottom to display most current message
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //remove all listeners
        ref.removeObserver(withHandle: handle)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        //Get Keyboard Dimensions
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        //Move the frame of the view with the keyboard
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    
    @objc func logOutTapped() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            AuthenticationManager.sharedInstance.loggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func sendTapped(_ sender: Any) {
        
        Flurry.logEvent("Chat-Sent") //Log event to track how many chats are sent 
        messageTextField.resignFirstResponder()
        
        
        guard let text = messageTextField.text, let id = AuthenticationManager.sharedInstance.userId,
            let name = AuthenticationManager.sharedInstance.userName, text.count > 0 else {return}
        
        let message = ["senderID" : id, "time" : NSTimeIntervalSince1970, "body" : text, "senderName" : name] as [String : Any]
        
        ref.child("chats").childByAutoId().setValue(message)
        
       
        messageTextField.text = ""
         
    }
}

extension ChatVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let id = AuthenticationManager.sharedInstance.userId!
        //Choose tableView Cell : UserCell or FriendCell
        if id == message.senderID {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
            cell.bodyLabel.text = message.body
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
            
            cell.bodyLabel.text = message.body
            cell.nameLabel.text = message.senderName
            return cell
        }
       
    }
}





















