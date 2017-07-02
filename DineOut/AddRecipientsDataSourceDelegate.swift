//
//  AddRecipentsDataSource.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 6/24/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class AddRecipientsDataSourceDelegate: NSObject {
    
    enum SearchState {
        case searchActivated
        case searchDismissed
    }
    
    fileprivate weak var addRecipentsViewController: AddRecipientsViewController?
    fileprivate var addRecipentsViewModel: AddRecipientsViewModel
    fileprivate var filteredResults: [Person] = []
    fileprivate var searchState: SearchState = .searchDismissed
    
    init(addRecipentsVC: AddRecipientsViewController) {
        self.addRecipentsViewController = addRecipentsVC
        self.addRecipentsViewModel = AddRecipientsViewModel()
    }
    
    // MARK: helper method
    func filter(from friends: [Person], with searchString: String) {
        let filteredByNameArray = friends.filter {
            $0.firstName.localizedCaseInsensitiveContains(searchString) || $0.lastName.localizedCaseInsensitiveContains(searchString)
        }
        filteredResults = filteredByNameArray
    }
}

extension AddRecipientsDataSourceDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend: Person
        if searchState == .searchActivated {
            friend = filteredResults[indexPath.row]
        } else {
            friend = addRecipentsViewModel.person(withIndexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableCell
        cell.profileImageView.image = UIImage(named: friend.profileImageName!)
        cell.userNameLabel.text = "@\(friend.userName)"
        cell.nameLabel.text = "\(friend.firstName) \(friend.lastName)"
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchState == .searchActivated {
            return filteredResults.count
        }
        return addRecipentsViewModel.numberOfRowInSection(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchState == .searchActivated {
            return 1
        }
        return addRecipentsViewModel.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchState == .searchActivated {
            return "Search Results"
        }
        return addRecipentsViewModel.titleForSection(section)
    }
}

extension AddRecipientsDataSourceDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt from datasource delegate")
    }
}

extension AddRecipientsDataSourceDelegate: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchState = .searchActivated
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change to \(searchText)")
        filter(from: addRecipentsViewModel.friends, with: searchText)
        addRecipentsViewController?.friendsListTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchState = .searchDismissed
        searchBar.resignFirstResponder()
        searchBar.text = ""
        addRecipentsViewController?.friendsListTableView.reloadData()
    }
}