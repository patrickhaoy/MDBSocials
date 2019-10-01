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
    @IBOutlet weak var dateTextField: UITextField!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTextField.inputView = datePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @IBAction func addPostPressed(_ sender: Any) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if socialNameTextField.text != "" && socialDescriptionTextField.text != "" && dateTextField.text != "" && dateFormatterGet.date(from: dateTextField.text!) {
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
