//
//  FriendItemsTableViewCell.swift
//  DineOut
//
//  Created by Zhang, Xiaolong on 7/12/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class FriendItemsTableViewCell: UITableViewCell {

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var editImageView: UIImageView!
  @IBOutlet weak var totalLabel: UILabel!
  @IBOutlet weak var itemNamesLabel: UILabel!
  @IBOutlet weak var itemPricesLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
