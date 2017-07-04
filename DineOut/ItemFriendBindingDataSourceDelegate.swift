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

extension ItemFriendBindingDataSourceDelegate: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (itemFriendBindingViewController?.selectedFriends?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendCollectionCell", for: indexPath) as? FriendCollectionViewCell, let dict = itemFriendBindingViewController?.selectedFriends {
            let friends = Array(dict.values)
            let friend = friends[indexPath.row]
            cell.userNameLabel.text = friend.userName
            cell.firstLastNameLabel.text = "\(friend.firstName) \(friend.lastName)"
            if let imageName = friend.profileImageName {
                cell.profileImageView.image = UIImage(named: "\(imageName)")
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension ItemFriendBindingDataSourceDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item \(indexPath.row) is selected")
    }
}

