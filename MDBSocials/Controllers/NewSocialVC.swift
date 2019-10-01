//
//  NewSocialVC.swift
//  MDBSocials
//
//  Created by Patrick Yin on 10/1/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase

class NewSocialVC: UIViewController {

    @IBOutlet weak var socialNameTextField: UITextField!
    @IBOutlet weak var socialDescriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addPostPressed(_ sender: Any) {
        if socialNameTextField.text != "" && socialDescriptionTextField.text != "" {
            let db = Database.database().reference()
            let socialsNode = db.child("Socials")
            let user = Auth.auth().currentUser
            let socialId = socialsNode.childByAutoId().key
            let socialNode = socialsNode.child(socialId!)
            let post = ["poster" : user!.uid, "socialName" : socialNameTextField.text!, "socialDescription" : socialDescriptionTextField.text!]
            socialNode.updateChildValues(post)
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields before adding a post.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
