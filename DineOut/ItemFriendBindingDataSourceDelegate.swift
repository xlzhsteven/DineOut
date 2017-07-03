//
//  ItemFriendBindingDataSourceDelegate.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 7/2/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class ItemFriendBindingDataSourceDelegate: NSObject {
    
    fileprivate weak var itemFriendBindingViewController: ItemFriendBindingViewController?
    fileprivate var addRecipentsViewModel: AddRecipientsViewModel
    
    init(itemFriendBindingVC: ItemFriendBindingViewController) {
        self.itemFriendBindingViewController = itemFriendBindingVC
        self.addRecipentsViewModel = AddRecipientsViewModel()
    }
}
