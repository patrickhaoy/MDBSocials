//
//  ViewController.swift
//  MDBSocials
//
//  Created by Patrick Yin on 10/1/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    @IBAction func loginPressed(_ sender: Any) {
        handleLogin()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "loginToSignup", sender: self)
    }
    
    func handleLogin() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        emailTextField.text = ""
        passwordTextField.text = ""
        let auth = Auth.auth()
        auth.signIn(withEmail: email, password: password) { (signedInUser, signInError) in
            guard signInError == nil else {
                self.displayAlert(title: "Error", message: "Sign In Error")
                return
            }
            guard signedInUser != nil else {
                self.displayAlert(title: "Error", message: "Sign In Error")
                return
            }
            self.performSegue(withIdentifier: "loginToFeed", sender: self)
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
}

