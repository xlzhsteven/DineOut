//
//  FriendCollectionViewCell.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 7/4/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit
import QuartzCore

class FriendCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstLastNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        profileImageView.layer.shadowColor = UIColor.darkGray.cgColor
        profileImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        profileImageView.layer.shadowOpacity = 1
        profileImageView.layer.shadowRadius = 2
        profileImageView.layer.masksToBounds = false
    }
}
