//
//  FriendPaymentDetailViewModel.swift
//  DineOut
//
//  Created by Zhang, Xiaolong on 7/12/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import Foundation

class FriendPaymentDetailViewModel: NSObject {
  var itemFriendsMap: [String: [Person]]?
  var friendItemsMap: [String: [Item]]?
  var selectedFriends: [String: Person]?
  var resultMap = [String: [Item]]()
  
  override init() {
    super.init()
  }
  
  func prepareData() {
    let friends = selectedFriends?.values
    for friend in friends! {
      resultMap[friend.userName] = []
    }
    for friend in friends! {
      for item in (friendItemsMap?[friend.userName]!)! {
        resultMap[friend.userName]?.append(getItemWithAdjustedPrice(item: item))
      }
    }
  }
  
  func getPersonFromUserName(_ userName: String) -> Person? {
    let friends = selectedFriends?.values
    for friend in friends! {
      if friend.userName == userName {
        return friend
      }
    }
    return nil
  }
  
  func getItemWithAdjustedPrice(item: Item) -> Item {
    let friendCountForItem = itemFriendsMap?[item.itemName!]?.count
    let priceAfterSharing = item.itemPrice!/Double(exactly: friendCountForItem!)!
    return Item(item.itemName!, priceAfterSharing)
  }
  
}
