//
//  DetailVC.swift
//  MDBSocials
//
//  Created by Patrick Yin on 10/2/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DetailVC: UIViewController {

    var selectedSocial: Social!
    @IBOutlet weak var socialName: UILabel!
    @IBOutlet weak var socialImage: UIImageView!
    @IBOutlet weak var socialDate: UILabel!
    @IBOutlet weak var socialDescription: UILabel!
    @IBOutlet weak var numOfInterested: UILabel!
    @IBOutlet weak var interestedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socialName.text = selectedSocial.socialName
        socialImage.image = selectedSocial.socialImage
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        socialDate.text = "Date: " + formatter.string(from: selectedSocial.socialDate)

        socialDescription.text = selectedSocial.socialDescription
        guard let interested = selectedSocial.interested else {
            numOfInterested.text = "0 interested!"
            return
        }
        numOfInterested.text = "\(selectedSocial.interested.count) interested!"
        
        if selectedSocial.interested.contains(Auth.auth().currentUser!.uid) {
            self.interestedButton.isEnabled = false
            self.interestedButton.setTitleColor(UIColor.gray, for: .disabled)
        } else {
            self.interestedButton.isEnabled = true
            self.interestedButton.setTitleColor(UIColor.black, for: .disabled)
        }
    }
    
    @IBAction func interestedPressed(_ sender: Any) {
        let socialNode = Database.database().reference().child("Socials").child(selectedSocial.socialId!)
        socialNode.observeSingleEvent(of: .value, with: { (snapshot) in
            let socialNodeDictionary = snapshot.value as? [String: Any] ?? [:]
            var interestedUsers = socialNodeDictionary["interested"] as? [String] ?? []
            
            if !interestedUsers.contains(Auth.auth().currentUser!.uid) {
                interestedUsers.append(Auth.auth().currentUser!.uid)
            }
            
            let post = ["interested" : interestedUsers]
            socialNode.updateChildValues(post)
            self.numOfInterested.text = "\(interestedUsers.count) interested!"
            self.interestedButton.isEnabled = false
            self.interestedButton.setTitleColor(UIColor.gray, for: .disabled)
        })
    }
}
