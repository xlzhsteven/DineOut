//
//  AddRecipentsDataSource.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 6/24/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class AddRecipientsDataSourceDelegate: NSObject {
    
    private weak var addRecipentsViewController: AddRecipientsViewController?
    fileprivate var addRecipentsViewModel: AddRecipientsViewModel
    
    init(addRecipentsVC: AddRecipientsViewController) {
        self.addRecipentsViewController = addRecipentsVC
        self.addRecipentsViewModel = AddRecipientsViewModel()
    }
}

extension AddRecipientsDataSourceDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableCell
        let friend = addRecipentsViewModel.person(withIndexPath: indexPath)
        cell.profileImageView.image = UIImage(named: friend.profileImageName!)
        cell.userNameLabel.text = "@\(friend.userName)"
        cell.nameLabel.text = "\(friend.firstName) \(friend.lastName)"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addRecipentsViewModel.numberOfRowInSection(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return addRecipentsViewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return addRecipentsViewModel.titleForSection(section)
    }
}

extension AddRecipientsDataSourceDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt from datasource delegate")
    }
}

extension AddRecipientsDataSourceDelegate: UISearchBarDelegate {
    override func didChangeValue(forKey key: String) {
        print("search bar has changed value")
    }
}
