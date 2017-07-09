//
//  Receipt.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 7/2/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import Foundation
import ObjectMapper

class Receipt: Mappable {

    var items: [Item]?
    var subTotal: Double?
    var tax: Double?
    var total: Double?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        items <- map["items"]
        subTotal <- map["subtotal"]
        tax <- map["tax"]
        total <- map["total"]
    }
    
}

class Item: Mappable {
    var itemName: String?
    var itemPrice: Double?
    var peopleAssociatedWithThisItem: [Person]?
  
    required init?(map: Map) {}
  
    init(_ itemName: String, _ itemPrice: Double, _ peopleAssociatedWithThisItem: [Person]) {
      self.itemName = itemName
      self.itemPrice = itemPrice
      self.peopleAssociatedWithThisItem = peopleAssociatedWithThisItem
    }
    
    func mapping(map: Map) {
        itemName <- map["itemName"]
        itemPrice <- map["price"]
    }
}
