//
//  ReviewViewDataSourceDelegate.swift
//  DineOut
//
//  Created by Zhang, Xiaolong on 7/12/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class ReviewViewDataSource: NSObject {
  fileprivate weak var reviewViewController: ReviewViewController?
  fileprivate var friendPaymentDetailViewModel: FriendPaymentDetailViewModel
  var itemFriendsMap: [String: [Person]]?
  var friendItemsMap: [String: [Item]]?
  var selectedFriends: [String: Person]?
  
  init(reviewVC: ReviewViewController) {
    self.reviewViewController = reviewVC
    self.friendPaymentDetailViewModel = FriendPaymentDetailViewModel()
  }
  
  func setupValues() {
    friendPaymentDetailViewModel.friendItemsMap = friendItemsMap
    friendPaymentDetailViewModel.itemFriendsMap = itemFriendsMap
    friendPaymentDetailViewModel.selectedFriends = selectedFriends
    friendPaymentDetailViewModel.prepareData()
  }
}

extension ReviewViewDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let state = reviewViewController?.splitState
    setupValues()
    let resultMap = friendPaymentDetailViewModel.resultMap
    let friendUserName = Array(selectedFriends!.keys)[indexPath.row]
    let friend = friendPaymentDetailViewModel.getPersonFromUserName(friendUserName)!
    let cell = tableView.dequeueReusableCell(withIdentifier: "friendPaymentDetailCell") as! FriendItemsTableViewCell
    cell.profileImageView.image = UIImage(named: (friend.profileImageName!))
    cell.nameLabel.text = "\(friend.firstName) \(friend.lastName)"
    var itemNames = ""
    var itemPrices = ""
    var totalPrice = 0.0
    for item in resultMap[friendUserName]! {
      itemNames += "\(item.itemName!)\n"
      itemPrices += "\(Helper.convertToCurrencyString(item.itemPrice!))\n"
      totalPrice += item.itemPrice!
    }
    if state == .confirm {
      let taxRate = UserDefaults.standard.double(forKey: "taxRate")
      cell.editImageView.image = nil
      let calculatedTip = Helper.calculateWith(value: totalPrice, andPercentage: (reviewViewController?.tipPercentage)!)
      let calculatedTax = Helper.calculateWith(value: totalPrice, andPercentage: taxRate)
      itemNames = "\(itemNames)Tip\nTax"
      itemPrices = "\(itemPrices)\(calculatedTip.string)\n\(calculatedTax.string)"
      totalPrice += calculatedTax.value + calculatedTip.value
    }
    cell.itemNamesLabel.text = itemNames
    cell.itemPricesLabel.text = itemPrices
    cell.totalLabel.text = "Total\t\(Helper.convertToCurrencyString(totalPrice))"
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedFriends!.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
}
