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
  @IBOutlet weak var topSectionView: UIView!
  @IBOutlet weak var userEditTextView: UITextView!
  
  var splitState: SplitState = .review
  var tipPercentage = 0.18
  var taxRate = 0.0924
  
  var itemFriendsMap: [String: [Person]]?
  var friendItemsMap: [String: [Item]]?
  var selectedFriends: [String: Person]?
  var paymentMessage: String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        reviewViewDataSource = ReviewViewDataSource(reviewVC: self)
        navigationItem.title = "Review"
      
      if splitState == .confirm {
        setupViewForConfirmationView()
        addSuccessTapGestureTo(view: splitButtonView)
      } else {
        addTapGestureTo(view: splitButtonView)
      }
    }
  
  func addTapGestureTo(view: UIView) {
    view.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    view.addGestureRecognizer(tap)
  }
  
  func addSuccessTapGestureTo(view: UIView) {
    view.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.showSuccessWithActivityPage(_:)))
    view.addGestureRecognizer(tap)
  }
  
  func showSuccessWithActivityPage(_ sender: UITapGestureRecognizer) {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let activityController = storyBoard.instantiateViewController(withIdentifier: "activityPage") as! ActivityViewController
    activityController.additionalActivities = prepareActivitiesFromFriendItemsMap()
    self.show(activityController, sender: self)
  }
  
  func prepareActivitiesFromFriendItemsMap() -> [Activity] {
    var activities = [Activity]()
    var activty: Activity?
    let sender = Person(firstName: "Suryatej", lastName: "Gundavelli", userName: "suryatejGundavelli", profileImageName: "user_suryatejgundavelli")
    let paymentMessage = self.paymentMessage!
    for friend in selectedFriends!.values {
      if friend.userName == sender.userName {
        continue
      }
      
      activty = Activity(sender: sender, receiver: friend, activityToDate: "0m", paymentMessage: paymentMessage, numberOfLikes: 0, numberOfComments: 0, transactionDirection: .requestMoney)
      activities.append(activty!)
    }
    return activities
  }
  
  func handleTap(_ sender: UITapGestureRecognizer) {
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let confirmViewController = storyBoard.instantiateViewController(withIdentifier: "reviewPage") as! ReviewViewController
    confirmViewController.itemFriendsMap = itemFriendsMap
    confirmViewController.friendItemsMap = friendItemsMap
    confirmViewController.selectedFriends = selectedFriends
    confirmViewController.paymentMessage = userEditTextView.text
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
    userEditTextView.resignFirstResponder()
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

extension ReviewViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == "What is it for?" {
      textView.text = nil
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    paymentMessage = textView.text
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text.contains("\n") {
      textView.resignFirstResponder()
      return false
    }
    
    return true
  }
}

extension ReviewViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    userEditTextView.resignFirstResponder()
  }
}

