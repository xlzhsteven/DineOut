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
    var addRecipentsViewModel: AddRecipientsViewModel
    fileprivate var searchState: SearchState = .searchDismissed
    
    init(addRecipentsVC: AddRecipientsViewController) {
        self.addRecipentsViewController = addRecipentsVC
        self.addRecipentsViewModel = AddRecipientsViewModel()
    }
    
    // MARK: helper method
    func filter(from friends: [Person], with searchString: String) {
        addRecipentsViewModel.filteredResults = friends.filter {
            $0.firstName.localizedCaseInsensitiveContains(searchString)
                || $0.lastName.localizedCaseInsensitiveContains(searchString)
                || $0.userName.localizedCaseInsensitiveContains(searchString)
        }
    }
    
    func inSearchMode() -> Bool {
        return searchState == .searchActivated && addRecipentsViewModel.filteredResults.count > 0
    }
}

extension AddRecipientsDataSourceDelegate: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend: Person
        let transactionMethod = addRecipentsViewController?.transactionMethod
      
        if inSearchMode() {
            friend = addRecipentsViewModel.filteredResults[indexPath.row]
        } else {
            friend = addRecipentsViewModel.person(withIndexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendTableCell
        cell.profileImageView.image = UIImage(named: friend.profileImageName!)
        cell.userNameLabel.text = "@\(friend.userName)"
        cell.nameLabel.text = "\(friend.firstName) \(friend.lastName)"
      
        if let _ = addRecipentsViewModel.selectedFriends[friend.userName] {
            cell.hasBeenSelected = true
        } else {
            cell.hasBeenSelected = false
        }
        if transactionMethod! == .normal {
          cell.infoIconImage.image = UIImage(named: "icInfoblack20")?.withRenderingMode(.alwaysTemplate)
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode() {
            return addRecipentsViewModel.filteredResults.count
        }
        return addRecipentsViewModel.numberOfRowInSection(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if inSearchMode() {
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
        print("didSelectRowAt indexpath row \(indexPath.row)")
        let person: Person
        addRecipentsViewController?.searchBar.resignFirstResponder()
        if inSearchMode() {
            person = addRecipentsViewModel.filteredResults[indexPath.row]
        } else {
            person = addRecipentsViewModel.person(withIndexPath: indexPath)
        }
        if let _ = addRecipentsViewModel.selectedFriends[person.userName] {
            // If element already exist in the selected list, click on the same item should remove item from list
            addRecipentsViewModel.selectedFriends.removeValue(forKey: person.userName)
        } else {
            // If element can't be found, add to the dictionary
            addRecipentsViewModel.selectedFriends[person.userName] = person
        }
        self.addRecipentsViewController?.friendsListTableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        addRecipentsViewController?.searchBar.resignFirstResponder()
    }
}

extension AddRecipientsDataSourceDelegate: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchState = .searchActivated
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print("text did change to \(searchText)")
    if searchText.isEmpty {
      searchState = .searchDismissed
    }
    filter(from: addRecipentsViewModel.friends, with: searchText)
    addRecipentsViewController?.friendsListTableView.delegate = nil
    addRecipentsViewController?.friendsListTableView.reloadData()
    addRecipentsViewController?.friendsListTableView.delegate = self
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchState = .searchDismissed
    searchBar.resignFirstResponder()
    searchBar.text = ""
    addRecipentsViewController?.friendsListTableView.reloadData()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    print("did end")
  }
  
  //    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
  //        searchState = .searchDismissed
  //        searchBar.text = ""
  //        addRecipentsViewController?.friendsListTableView.reloadData()
  //    }
}
