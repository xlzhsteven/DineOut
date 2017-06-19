//
//  Person.swift
//  DineOut
//
//  Created by Zhang, Xiaolong on 6/18/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class Person: NSObject {
    var firstName: String
    var lastName: String
    var userName: String
    
    init(firstName: String, lastName: String, userName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
    }
}
