//
//  AddRecipientsViewController.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 6/24/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class AddRecipientsViewController: UIViewController {
    
    enum TransactionMethod {
        case normal
        case splitBill
    }
    
    var transactionMethod: TransactionMethod = .normal
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendsListTableView: UITableView!
    @IBOutlet weak var selectAllFriendsUiView: UIView!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backButtonClicked))
        addRecipientsViewDataSource = AddRecipientsDataSourceDelegate(addRecipentsVC: self)
        friendsListTableView.rowHeight = UITableViewAutomaticDimension
        friendsListTableView.estimatedRowHeight = 80
        if transactionMethod == .splitBill {
            showSelectAllFriendsUIView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func backButtonClicked() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func showSelectAllFriendsUIView() {
        selectAllFriendsUiView.isHidden = false
        searchBarTopConstraint.constant = selectAllFriendsUiView.bounds.height
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonClicked))
        navigationItem.title = "Dine Out"
    }
    
    func nextButtonClicked() {
        print("segueway to DineOut page")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemFriendBindingViewController = storyBoard.instantiateViewController(withIdentifier: "itemFriendBinding") as! ItemFriendBindingViewController
        itemFriendBindingViewController.selectedFriends = addRecipientsViewDataSource?.addRecipentsViewModel.selectedFriends
        self.show(itemFriendBindingViewController, sender: self)
    }
    
    var addRecipientsViewDataSource: AddRecipientsDataSourceDelegate? {
        didSet {
            if let dataSourceDelegate = self.addRecipientsViewDataSource {
                self.friendsListTableView.dataSource = dataSourceDelegate
                self.friendsListTableView.delegate = dataSourceDelegate
                self.searchBar.delegate = dataSourceDelegate
            }
        }
    }
}
