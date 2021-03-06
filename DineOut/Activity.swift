//
//  Activity.swift
//  DineOut
//
//  Created by Zhang, Xiaolong on 6/18/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import Foundation

class Activity: NSObject {
    var sender: Person
    var receiver: Person
    var activityToDate: String
    var paymentMessage: String
    var numberOfLikes: Int
    var numberOfComments: Int
    var amount: Double?
    var transactionDirection: MoneyTransactionDirection
		
  
  init(sender: Person, receiver: Person, activityToDate: String, paymentMessage: String, numberOfLikes: Int, numberOfComments: Int, amount: Double? = 0, transactionDirection: MoneyTransactionDirection) {
        self.sender = sender
        self.receiver = receiver
        self.activityToDate = activityToDate
        self.paymentMessage = paymentMessage
        self.numberOfLikes = numberOfLikes
        self.numberOfComments = numberOfComments
        self.amount = amount
        self.transactionDirection = transactionDirection
    }
    
}

enum MoneyTransactionDirection: String {
  case requestMoney = "requested money from"
  case sendMoney = "paid"
}
