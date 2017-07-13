//
//  ReviewViewController.swift
//  DineOut
//
//  Created by Zhang, Xiaolong on 7/12/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {
  
  enum SplitState {
    case review
    case confirm
  }

  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tipSelectionSegment: UISegmentedControl!
  @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var splitTextLabel: UILabel!
  @IBOutlet weak var splitButtonView: UIView!
  
  var splitState: SplitState = .review
  var tipPercentage = 0.18
  var taxRate = 0.09
  
  var itemFriendsMap: [String: [Person]]?
  var friendItemsMap: [String: [Item]]?
  var selectedFriends: [String: Person]?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        reviewViewDataSource = ReviewViewDataSource(reviewVC: self)
        navigationItem.title = "Review"
      
      if splitState == .confirm {
        setupViewForConfirmationView()
        addSuccessAlertTapGestureTo(view: splitButtonView)
      } else {
        addTapGestureTo(view: splitButtonView)
      }
    }
  
  func addTapGestureTo(view: UIView) {
    view.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    view.addGestureRecognizer(tap)
  }
  
  func addSuccessAlertTapGestureTo(view: UIView) {
    view.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.showAlertWithSuccessMessage(_:)))
    view.addGestureRecognizer(tap)
  }
  
  func showAlertWithSuccessMessage(_ sender: UITapGestureRecognizer) {
    let alert = UIAlertController(title: "Success", message: "You have successfully splitted your bill", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  func handleTap(_ sender: UITapGestureRecognizer) {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let confirmViewController = storyBoard.instantiateViewController(withIdentifier: "reviewPage") as! ReviewViewController
    confirmViewController.itemFriendsMap = itemFriendsMap
    confirmViewController.friendItemsMap = friendItemsMap
    confirmViewController.selectedFriends = selectedFriends
    confirmViewController.splitState = .confirm
    self.show(confirmViewController, sender: self)
  }
  
  func setupViewForConfirmationView() {
    navigationItem.title = "Total with tax and tip"
    topView.isHidden = true
    tableViewTopConstraint.constant = -topView.frame.height
    splitButtonView.backgroundColor = UIColor(red:0.45, green:0.73, blue:0.31, alpha:1.00)
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  @IBAction func segmentedControlValueChanged(_ sender: Any) {
    switch (sender as AnyObject).selectedSegmentIndex {
    case 0:
      tipPercentage = 0.15
    case 1:
      tipPercentage = 0.18
    case 2:
      tipPercentage = 0.2
    default:
      tipPercentage = 0.18
    }
  }
  
  var reviewViewDataSource: ReviewViewDataSource? {
    didSet {
      if let dataSource = self.reviewViewDataSource {
        self.reviewViewDataSource?.itemFriendsMap = itemFriendsMap
        self.reviewViewDataSource?.friendItemsMap = friendItemsMap
        self.reviewViewDataSource?.selectedFriends = selectedFriends
        self.tableView.dataSource = dataSource
      }
    }
  }
}

