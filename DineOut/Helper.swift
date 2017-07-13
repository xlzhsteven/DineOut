//
//  Helper.swift
//  DineOut
//
//  Created by Zhang, Xiaolong on 7/12/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import Foundation
class Helper: NSObject {
  class func convertToCurrencyString(_ amount: Double) -> String {
    let formatter = NumberFormatter()
    let price = amount as NSNumber
    formatter.numberStyle = .currency
    return formatter.string(from: price)!
  }
  
  class func calculateWith(value amount: Double, andPercentage percentage: Double) -> (string: String, value: Double) {
    let result = amount * percentage
    return (convertToCurrencyString(result), result)
  }
  
}
