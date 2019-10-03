//
//  FeedVC.swift
//  MDBSocials
//
//  Created by Patrick Yin on 10/1/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FeedVC: UIViewController {
    var socials: [Social]! = []
    @IBOutlet weak var socialsTableView: UITableView!
    var currentIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        getAllSocials()
        addNewSocial()
        updateSocials()
    }
    
    func setUpNavBar() {
        self.navigationItem.title = "Feed"
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.leftBarButtonItem = logOutButton
        let newSocialButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addSocialPressed))
        self.navigationItem.rightBarButtonItem = newSocialButton
    }
    
    @objc func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addSocialPressed() {
        self.performSegue(withIdentifier: "feedToSocial", sender: self)
    }
    
    
    func getAllSocials() {
        let socialsNode = Database.database().reference().child("Socials")
        let imagesNode = Storage.storage().reference().child("images")
        
        socialsNode.observeSingleEvent(of: .value, with: { (snapshot) in
            let socialDict = snapshot.value as? [String:Any] ?? [:]
            var allSocials: [Social] = []
            
            for (key, value) in socialDict {
                let currentSocial = Social(socialId: key, social: value as! [String : Any])
                let currentSocialImage = imagesNode.child(key)
                print(currentSocialImage)
                currentSocialImage.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                    guard error != nil else {
                        return
                    }
                    guard data != nil else {
                        print("All events: dazta is nil")
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
                    print("New events: data is nil")
                    return
                }
                social.socialImage = UIImage(data: data!)
            }
            self.socials.append(social)
            self.socials.sort(by: {$0.socialDate > $1.socialDate})
            self.socialsTableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "feedToDetail":
                let destinationVC = segue.destination as! DetailVC
                destinationVC.selectedSocial = socials[currentIndexPath.row]
            default: break
        }
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
