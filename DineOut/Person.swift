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
    var profileImageName: String?
    
    init(firstName: String, lastName: String, userName: String, profileImageName: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.userName = userName
        self.profileImageName = profileImageName
    }
}
