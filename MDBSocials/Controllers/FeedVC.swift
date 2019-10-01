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

    override func viewDidLoad() {
        super.viewDidLoad()
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
}
