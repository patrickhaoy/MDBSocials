//
//  File.swift
//  MDBSocials
//
//  Created by Patrick Yin on 10/2/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import Foundation
import UIKit

class Social {
    
    var socialId: String?
    var socialName: String?
    var socialDescription: String?
    var socialDate: Date!
    
    var poster: String?
    var socialImage: UIImage?
    var interested: [String]!
    
    init(socialId: String, social: [String: Any]) {
        self.socialId = socialId
        
        if social["socialName"] as? String == "" {
            self.socialName = "Default Title"
        } else {
            self.socialName = social["socialName"] as? String
        }
        
        if social["socialDescription"] as? String == "" {
            self.socialDescription = "Default Description"
        } else {
            self.socialDescription = social["socialDescription"] as? String
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.socialDate = dateFormatter.date(from: social["socialDate"] as! String)!
        
        if social["poster"] as? String == "" {
            self.poster = "Anonymous"
        } else {
            self.poster = social["poster"] as? String
        }
        
        self.socialImage = UIImage(named: "question_mark")
        
        if social["interested"] as? String == "" {
            self.interested = []
        } else {
            self.interested = social["interested"] as? [String]
        }
    }
}
