//
//  SignUpVC.swift
//  MDBSocials
//
//  Created by Patrick Yin on 10/1/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard nameTextField.text != "" else {
            displayAlert(title: "Incomplete", message: "Please enter your name")
            return
        }
        guard emailTextField.text != "" else {
            displayAlert(title: "Incomplete", message: "Please enter your email")
            return
        }
        guard usernameTextField.text != "" else {
            displayAlert(title: "Incomplete", message: "Please enter your username")
            return
        }
        guard passwordTextField.text != "" else {
            displayAlert(title: "Incomplete", message: "Please enter your password")
            return
        }
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            guard error == nil else {
                self.displayAlert(title: "Error", message: "Registration Error")
                return
            }
            guard user != nil else {
                self.displayAlert(title: "Error", message: "Registration Error")
                return
            }
            let db = Database.database().reference()
            let usersNode = db.child("Users")
            let newUserId = usersNode.childByAutoId().key
            let userNode = usersNode.child(newUserId!)
            userNode.updateChildValues(["name": self.nameTextField.text!, "username": self.usernameTextField.text!, "email": self.emailTextField.text!])
            self.performSegue(withIdentifier: "signupToFeed", sender: self)
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
}
