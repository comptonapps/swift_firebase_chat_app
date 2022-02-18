//
//  SignUpVC.swift
//  Section4-8ChatApp
//
//  Created by Jonathan Compton on 7/5/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()


    }

    @IBAction func signUpTapped(_ sender: Any) {
        guard let name = usernameTextField.text,
        let email = emailTextField.text,
        let password = passwordTextField.text,
        name.count > 0,
        email.count > 0,
        password.count > 0
            else {
                //ERROR SERVICE
                print("error")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                //ERROR SERVICE
                print("error")
                return
            }
            if let user = result?.user {
                self.setUserName(user: user, name: name)
                let userInfo = ["name" : name,
                                "email" : email,
                                ]
                self.ref.child("users").child(user.uid).setValue(userInfo)
            }
        }
    }
    
    func setUserName(user: User, name: String) {
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        
        changeRequest.commitChanges { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            AuthenticationManager.sharedInstance.didLogIn(user: user)
            self.performSegue(withIdentifier: "toAllUsersVCFromSignUpVC", sender: nil)
        }
    }
    

}
