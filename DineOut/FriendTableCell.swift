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
    let iconColor = UIColor(red: 0.21, green: 0.53, blue: 0.78, alpha: 1)
    var hasBeenSelected: Bool = false {
        didSet {
            setInfoIcon()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setInfoIcon()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setInfoIcon(withImageName imageName: String, withColor color: UIColor) {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        infoIconImage.tintColor = color
        infoIconImage.image = image
    }
    
    func setInfoIcon() {
        if hasBeenSelected {
            setInfoIcon(withImageName: "ic_checkmark", withColor: iconColor)
        } else {
            infoIconImage.image = nil
        }
    }
}


