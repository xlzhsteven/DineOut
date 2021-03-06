//
//  ActivityViewModel.swift
//  DineOut
//
//  Created by Zhang, Xiaolong on 6/18/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import Foundation

class ActivityViewModel: NSObject {
    
    var activities: [Activity] = []
    
    override init() {
        super.init()
    }
  
    func addActivity(toActivityList activityList: [Activity]) {
        activities.insert(contentsOf: activityList, at: 0)
    }
  
    func loadActivities() {
      activities.append(Activity(sender: Person(firstName: "Carrie", lastName: "Erickson", userName: "carrieErickson", profileImageName: "user_carrieerickson"), receiver: Person(firstName: "Edmand", lastName: "Smith", userName: "edmandSmith"), activityToDate: "3h", paymentMessage: "Feb 2017 rent 🏡", numberOfLikes: 4, numberOfComments: 2, transactionDirection: .sendMoney))
        
        activities.append(Activity(sender: Person(firstName: "Helen", lastName: "Estrada", userName: "helenEstrada", profileImageName: "user_helenestrada"), receiver: Person(firstName: "Joxie", lastName: "Patterson", userName: "joxiePatterson"), activityToDate: "1d", paymentMessage: "Best vegan lunch 🌳🌳", numberOfLikes: 1, numberOfComments: 1, transactionDirection: .sendMoney))
        
        activities.append(Activity(sender: Person(firstName: "Suryatej", lastName: "Gundavelli", userName: "suryatejGundavelli", profileImageName: "user_suryatejgundavelli"), receiver: Person(firstName: "Bryan", lastName: "Kying", userName: "bryanKying"), activityToDate: "2d", paymentMessage: "Thanks for hanging out with us today! Would be great to do this regularly, maybe every two weeks?", numberOfLikes: 0, numberOfComments: 0, amount: -32, transactionDirection: .sendMoney))
        
        activities.append(Activity(sender: Person(firstName: "Kevin", lastName: "Ward", userName: "kevinWard", profileImageName: "user_kevinward"), receiver: Person(firstName: "Ye", lastName: "Carlson", userName: "yeCharlson"), activityToDate: "2d", paymentMessage: "Copenhagen trip 🚲🛬", numberOfLikes: 0, numberOfComments: 0, transactionDirection: .sendMoney))
    }
    
    func numberOfRowInSection() -> Int {
        return activities.count
    }
    
    func activity(withIndex index: Int) -> Activity {
        return activities[index]
    }
    
    func numberOfSection() -> Int {
        return 1
    }
    
}


