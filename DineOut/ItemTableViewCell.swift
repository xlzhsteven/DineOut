//
//  ItemTableViewCell.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 7/3/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    var listOfFriends: [Person] = []
    var item: Item?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
