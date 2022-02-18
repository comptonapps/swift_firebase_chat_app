//
//  AllUsersVC.swift
//  Section4-8ChatApp
//
//  Created by Jonathan Compton on 7/5/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import Firebase

class AllUsersVC: UIViewController {
    
    var allUsers = [ChatUser]()
    var selectedUserArray = [String]()
    var ref : DatabaseReference!
    var handle : DatabaseHandle!
   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Chat Users"
        ref = Database.database().reference()
        let barButton = UIBarButtonItem(title: "Chat!", style: .plain, target: self, action: #selector(chatTapped))
        navigationItem.rightBarButtonItem = barButton
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("vwa \(selectedUserArray)")
        allUsers.removeAll()
        //selectedUserArray.removeAll()
        handle = ref.child("users").observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? [String: AnyObject] {
                let name = value["name"] as! String
                let email = value["email"] as! String
                let id = snapshot.key
                var isSelected = false
                if self.selectedUserArray.contains(id){
                    isSelected = true
                }
                
                let user = ChatUser(id: id, name: name, email: email, selected: isSelected)
                if id != AuthenticationManager.sharedInstance.userId! {
                    self.allUsers.append(user)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }
    
    @objc func chatTapped() {
        self.performSegue(withIdentifier: "segue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            let destinationVC = segue.destination as! ChatVC
            destinationVC.selectedUserArray = selectedUserArray
        }
    }


}

extension AllUsersVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.accessoryType = .none
        let user = allUsers[indexPath.row]
        if user.selected {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
}

extension AllUsersVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var index = 0
        let user = allUsers[indexPath.row]
        user.selected = !user.selected
        if user.selected {
            selectedUserArray.append(user.id)
        } else {
            for chatUser in selectedUserArray {
                if user.id == chatUser {
                    selectedUserArray.remove(at: index)
                    break
                }
                index += 1
            }
        }
        print(selectedUserArray)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}


