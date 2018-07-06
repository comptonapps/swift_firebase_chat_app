//
//  ChatVC.swift
//  Section4-8ChatApp
//
//  Created by Jonathan Compton on 7/5/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import Firebase


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
        messageTextField.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messages.removeAll()
        
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
                }
                
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
    }
    @IBAction func sendTapped(_ sender: Any) {
        messageTextField.resignFirstResponder()
        guard let text = messageTextField.text, let id = AuthenticationManager.sharedInstance.userId,
            let name = AuthenticationManager.sharedInstance.userName, text.count > 0 else {return}
        
        let message = ["senderID" : id, "time" : NSTimeIntervalSince1970, "body" : text, "senderName" : name] as [String : Any]
        
        ref.child("chats").childByAutoId().setValue(message)
    }
}

extension ChatVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.body
        cell.detailTextLabel?.text = message.senderName
        return cell
    }
}





















