//
//  AddRecipientsViewController.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 6/24/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class AddRecipientsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendsListTableView: UITableView!
    @IBOutlet weak var selectAllFriendsUiView: UIView!
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backButtonClicked))
        addRecipientsViewDataSource = AddRecipientsDataSource(addRecipentsVC: self)
//        showSelectAllFriendsUIView()
        friendsListTableView.rowHeight = UITableViewAutomaticDimension
        friendsListTableView.estimatedRowHeight = 80
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
    }
    
    var addRecipientsViewDataSource: AddRecipientsDataSource? {
        didSet {
            if let dataSource = self.addRecipientsViewDataSource {
                self.friendsListTableView.dataSource = dataSource
            }
        }
    }
    
}
