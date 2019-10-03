//
//  NewSocialVC-TextView.swift
//  MDBSocials
//
//  Created by Patrick Yin on 10/2/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase

extension NewSocialVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Social Description"
            textView.textColor = UIColor.lightGray
        }
    }}
