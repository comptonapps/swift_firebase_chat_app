//
//  LoginVC.swift
//  Section4-8ChatApp
//
//  Created by Jonathan Compton on 7/5/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    @IBAction func logInTapped(_ sender: Any) {
        guard let email = emailTextField.text,
        let password = passwordTextField.text,
        email.count > 0,
        password.count > 0 else {
            //ERROR SERVICE
            print("error")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                //ERROR SERVICE
                print("error")
                return
            }
            if let user = result?.user {
                AuthenticationManager.sharedInstance.didLogIn(user: user)
                self.performSegue(withIdentifier: "toAllUsersVCFromLoginVC", sender: nil)
            }
        }
    }
    
}
