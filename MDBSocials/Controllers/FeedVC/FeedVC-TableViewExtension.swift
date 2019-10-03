//
//  FeedVC-TableViewExtension.swift
//  MDBSocials
//
//  Created by Patrick Yin on 10/1/19.
//  Copyright © 2019 Patrick Yin. All rights reserved.
//

import UIKit

extension FeedVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socials.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialCell") as! SocialCell
        cell.posterLabel.text = "Hosted by " + socials[indexPath.row].poster!
        cell.socialNameLabel.text = socials[indexPath.row].socialName
        cell.socialImageView.image = socials[indexPath.row].socialImage
        guard let interested = socials[indexPath.row].interested else {
            cell.numOfInterestedLabel.text = "0 interested!"
            return cell
        }
        cell.numOfInterestedLabel.text = "\(socials[indexPath.row].interested.count) interested!"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentIndexPath = indexPath
        self.performSegue(withIdentifier: "feedToDetail", sender: self)
    }
}
