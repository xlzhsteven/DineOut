//
//  AddRecipientsViewModel.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 6/24/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import Foundation

class AddRecipientsViewModel: NSObject {
    var friends: [Person] = []
    var topPeople: [Person] = []
    var filteredResults: [Person] = []
    var selectedFriends = [String: Person]()
    
    override init() {
        super.init()
        loadPeople()
        selectedFriends["suryatejGundavelli"] = Person(firstName: "Me", lastName: "", userName: "suryatejGundavelli", profileImageName: "user_suryatejgundavelli")
    }
    
    func loadPeople() {
        friends.append(Person(firstName: "Carrie", lastName: "Erickson", userName: "carrieErickson", profileImageName: "user_carrieerickson"))
        friends.append(Person(firstName: "Helen", lastName: "Estrada", userName: "helenEstrada", profileImageName: "user_helenestrada"))
        friends.append(Person(firstName: "Josh", lastName: "Applebaum", userName: "joshApplebaum", profileImageName: "user_joshapplebaum"))
        friends.append(Person(firstName: "Justin", lastName: "Kuo", userName: "justinKuo", profileImageName: "user_justinkuo"))
        friends.append(Person(firstName: "Kevin", lastName: "Ward", userName: "kevinWard", profileImageName: "user_kevinward"))
        friends.append(Person(firstName: "Sophie", lastName: "Lewis", userName: "sophieLewis", profileImageName: "user_sophielewis"))
        friends.append(Person(firstName: "Xiaolong", lastName: "Zhang", userName: "xiaolongzhang", profileImageName: "user_xiaolongzhang"))
        friends.append(Person(firstName: "Vanessa", lastName: "Hudson", userName: "vanessaHudson", profileImageName: "user_vanessahudson"))
        
        topPeople.append(Person(firstName: "Kevin", lastName: "Ward", userName: "kevinWard", profileImageName: "user_kevinward"))
        topPeople.append(Person(firstName: "Justin", lastName: "Kuo", userName: "justinKuo", profileImageName: "user_justinkuo"))
    }
    
    func numberOfRowInSection(_ section: Int) -> Int {
        if section == 0 {
            return topPeople.count
        } else {
            return friends.count
        }
    }
    
    func titleForSection(_ section: Int) -> String {
        if section == 0 {
            return "Top People"
        } else {
            return "Friends"
        }
    }
    
    func person(withIndexPath indexPath: IndexPath) -> Person {
        let section = indexPath.section
        if section == 0 {
            return topPeople[indexPath.row]
        } else {
            return friends[indexPath.row]
        }
    }
    
    func numberOfSection() -> Int {
        return 2
    }
}
