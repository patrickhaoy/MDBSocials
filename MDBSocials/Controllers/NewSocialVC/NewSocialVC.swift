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
    @IBOutlet weak var socialDescriptionTextField: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        dateTextField.inputView = datePicker
        
        socialDescriptionTextField.text = "Social Description"
        socialDescriptionTextField.textColor = UIColor.lightGray
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
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func addPostPressed(_ sender: Any) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if socialNameTextField.text != "" && socialDescriptionTextField.text != "" && dateTextField.text != "" && (dateFormatterGet.date(from: dateTextField.text!) != nil) && imageView.image != nil {
            let db = Database.database().reference()
            let socialsNode = db.child("Socials")
            let user = Auth.auth().currentUser
            let socialId = socialsNode.childByAutoId().key
            
            //Add Image to Storage
            let imageRef = Storage.storage().reference().child("images").child(socialId!)
            var imageData = imageView.image!.jpegData(compressionQuality: 0.1)
            
            print("NewSocialVC: ", imageData)
            imageRef.putData(imageData!, metadata: nil) { (metadata, err) in
                if err != nil {
                    self.displayAlert(title: "Error", message: "Error uploading image")
                    return
                }
                //Add to Realtime Database
                let socialNode = socialsNode.child(socialId!)
                let usersNode = db.child("Users")
                usersNode.child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let userInfo = snapshot.value as? [String:Any] ?? [:]
                    let post = ["poster" : userInfo["name"], "socialName" : self.socialNameTextField.text!, "socialDescription" : self.socialDescriptionTextField.text!, "socialDate": self.dateTextField.text!]
                    socialNode.updateChildValues(post)
                })
            }
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields appropriately before adding a post.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
        
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
}
