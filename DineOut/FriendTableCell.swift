//
//  FriendTableCell.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 6/24/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class FriendTableCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var infoIconImage: UIImageView!
    var hasBeenSelected: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let iconColor = UIColor(red: 0.21, green: 0.53, blue: 0.78, alpha: 1)
        setInfoIcon(withColor: iconColor)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setInfoIcon(withColor color: UIColor) {
        let image = UIImage(named:"icInfoblack20")?.withRenderingMode(.alwaysTemplate)
        infoIconImage.tintColor = color
        infoIconImage.image = image
    }
}


