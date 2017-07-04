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
    fileprivate var receipt: Receipt?
    fileprivate var receiptViewModel: ReceiptViewModel?
    
    init(itemFriendBindingVC: ItemFriendBindingViewController) {
        self.itemFriendBindingViewController = itemFriendBindingVC
        self.addRecipentsViewModel = AddRecipientsViewModel()
        self.receiptViewModel = ReceiptViewModel()
    }
    
    func loadItemData() {
        self.receiptViewModel?.loadData(success: { (receiptResponse) in
            self.receipt = receiptResponse
            self.itemFriendBindingViewController?.itemListTableView.reloadData()
        })
    }
}

extension ItemFriendBindingDataSourceDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {    
        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell,
            let item = self.receipt?.items?[indexPath.row],
            let itemPrice = item.itemPrice {
            cell.itemNameLabel.text = item.itemName
            cell.itemPriceLabel.text = String(format: "$%.02f", locale: Locale.current, arguments: [itemPrice])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.receipt?.items?.count {
            return count
        } else {
            return 0
        }
    }
}

extension ItemFriendBindingDataSourceDelegate: UITableViewDelegate {

}
