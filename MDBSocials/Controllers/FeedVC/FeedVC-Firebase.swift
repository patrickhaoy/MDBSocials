//
//  FeedVC-Firebase.swift
//  MDBSocials
//
//  Created by Patrick Yin on 10/2/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

extension FeedVC {
    func getAllSocials() {
        let socialsNode = Database.database().reference().child("Socials")
        let imagesNode = Storage.storage().reference().child("images")
        
        socialsNode.observeSingleEvent(of: .value, with: { (snapshot) in
            let socialDict = snapshot.value as? [String:Any] ?? [:]
            var allSocials: [Social] = []
            
            for (key, value) in socialDict {
                let currentSocial = Social(socialId: key, social: value as! [String : Any])
                let currentSocialImage = imagesNode.child(key)
                print("getAllSocials", currentSocialImage)
                currentSocialImage.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                    guard error != nil else {
                        return
                    }
                    guard data != nil else {
                        print("All events: data is nil")
                        return
                    }
                    currentSocial.socialImage = UIImage(data: data!)
                }
                allSocials.append(currentSocial)
            }
            self.socials = allSocials.sorted(by: { $0.socialDate > $1.socialDate })
            self.socialsTableView.reloadData()
        })
    }
    
    func addNewSocial() {
        let socialsNode = Database.database().reference().child("Socials")
        let imagesNode = Storage.storage().reference().child("images")
        
        socialsNode.observe(.childAdded, with: { (snapshot) in
            let newSocial = snapshot.value as? [String:Any] ?? [:]
            let social = Social(socialId: snapshot.key, social: newSocial)
            let socialImage = imagesNode.child(snapshot.key)
            socialImage.getData(maxSize: 1 * 1024 * 1024) { data, error in
                guard error != nil else {
                    return
                }
                guard data != nil else {
                    print("AddNewSocial: data is nil")
                    return
                }
                social.socialImage = UIImage(data: data!)
            }
            self.socials.append(social)
            self.socials.sort(by: {$0.socialDate > $1.socialDate})
            self.socialsTableView.reloadData()
        })
    }
    
    func updateSocials() {
        let socialNode = Database.database().reference().child("Socials")

        socialNode.observe(DataEventType.childChanged, with: { (snapshot) in
            let changedSocial = snapshot.value as? [String:Any] ?? [:]
            let social = Social(socialId: snapshot.key, social: changedSocial)
            let changedSocialIndex = self.socials.firstIndex(where: {$0.socialId == social.socialId})
            social.socialImage = self.socials[changedSocialIndex!].socialImage
            self.socials![changedSocialIndex!] = social
            self.socialsTableView.reloadData()
        })
    }
}