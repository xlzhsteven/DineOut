//
//  ItemFriendBindingViewController.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 7/2/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit
import Foundation

class ItemFriendBindingViewController: UIViewController {
    
    @IBOutlet weak var itemListTableView: UITableView!
    @IBOutlet weak var friendListCollectionView: UICollectionView!
    @IBOutlet var containerView: UIView!
    var selectedFriends: [String: Person]?
    var receipt: Receipt?
    var itemFriendsMap: [String: [Person]] = [:]
    var friendItemsMap: [String: [Item]] = [:]
  
    var itemFriendBindingDataSourceDelegate: ItemFriendBindingDataSourceDelegate? {
        didSet {
            if let dataSourceDelegate = self.itemFriendBindingDataSourceDelegate {
                self.itemListTableView.dataSource = dataSourceDelegate
                self.itemListTableView.delegate = dataSourceDelegate
              let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized))
                self.friendListCollectionView.addGestureRecognizer(longpress)
                self.friendListCollectionView.dataSource = dataSourceDelegate
                self.friendListCollectionView.delegate = dataSourceDelegate
                dataSourceDelegate.loadItemData(receipt!)
                initItemFriendsMapWithKeys(receipt!)
                initFriendItemsMapWithKeys(Array(selectedFriends!.values))
            }
        }
    }
  
    func initItemFriendsMapWithKeys(_ receipt: Receipt) {
      let items = receipt.items
      for item in items! {
        itemFriendsMap[item.itemName!] = []
      }
    }
  
    func initFriendItemsMapWithKeys(_ selectedFriends: [Person]) {
      for friend in selectedFriends {
        friendItemsMap[friend.userName] = []
      }
    }
  
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
      let longPress = gestureRecognizer as! UILongPressGestureRecognizer
      let state = longPress.state
      
      // Location in relative to both collection view as well as table view
      let locationInTableView = longPress.location(in: itemListTableView)
      let locationInCollectionView = longPress.location(in: friendListCollectionView)
      
//      print("table view: x:\(locationInTableView.x), y: \(locationInTableView.y)")
//      print("collection view: x:\(locationInCollectionView.x), y: \(locationInCollectionView.y)")
      
      // Which index is it in relate to both table and collection view
      let tableIndexPath = itemListTableView.indexPathForRow(at: locationInTableView)
      let collectionIndexPath = friendListCollectionView.indexPathForItem(at: locationInCollectionView)
//      print("table indexpath is \(String(describing: tableIndexPath?.row))")
//      print("collection indexpath is \(String(describing: collectionIndexPath?.row))")
      
      struct My {
        static var cellSnapshot : UIView? = nil
        static var cellIsAnimating : Bool = false
        static var cellNeedToShow : Bool = false
      }
      struct Path {
        static var initialIndexPath: IndexPath?
        static var finalTableIndexPath: IndexPath?
      }
      
      switch state {
      case .began:
        if collectionIndexPath != nil {
          Path.initialIndexPath = collectionIndexPath
          let cell = friendListCollectionView.cellForItem(at: collectionIndexPath!) as! FriendCollectionViewCell
          My.cellSnapshot = snapshotOfCell((cell.friend?.profileImageName)!)
          
          let center = calculateSnapShotLocation(cell, locationInTableView)
          My.cellSnapshot?.center = center
          My.cellSnapshot?.alpha = 0
          containerView.addSubview(My.cellSnapshot!)
          
          UIView.animate(withDuration: 0.25, animations: { () -> Void in
            My.cellIsAnimating = true
            My.cellSnapshot!.center = center
            My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            My.cellSnapshot!.alpha = 0.98
            cell.alpha = 0.0
          }, completion: { (finished) -> Void in
            if finished {
              My.cellIsAnimating = false
              if My.cellNeedToShow {
                My.cellNeedToShow = false
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                  cell.alpha = 1
                })
              } else {
                cell.isHidden = true
              }
            }
          })
        }
        
      case .changed:
        if My.cellSnapshot != nil {
          var center = My.cellSnapshot!.center
          center.y = locationInTableView.y + My.cellSnapshot!.frame.size.height/2
          center.x = locationInTableView.x
          My.cellSnapshot!.center = center
          Path.finalTableIndexPath = tableIndexPath
        }
        
        
      default:
        if Path.initialIndexPath != nil {
          let friendCell = friendListCollectionView.cellForItem(at: Path.initialIndexPath!) as! FriendCollectionViewCell
          if My.cellIsAnimating {
            My.cellNeedToShow = true
          } else {
            friendCell.isHidden = false
            friendCell.alpha = 0.0
          }
          
          if Path.finalTableIndexPath != nil {
            let itemCell = itemListTableView.cellForRow(at: Path.finalTableIndexPath!) as! ItemTableViewCell
            addFriendToItem(itemCell, friendCell)
//            let addImage = friendCell.profileImageView.image
//            let imageView = UIImageView(image: addImage)
//            imageView.frame = CGRect(x: 24, y: 35, width: 30, height: 30)
//            itemCell.addSubview(imageView)
          }
          
          UIView.animate(withDuration: 0.25, animations: { () -> Void in
//            My.cellSnapshot!.center = self.calculateSnapShotLocation(friendCell, locationInTableView)
            My.cellSnapshot!.transform = CGAffineTransform.identity
            My.cellSnapshot!.alpha = 0.0
            friendCell.alpha = 1.0
            
          }, completion: { (finished) -> Void in
            if finished {
              Path.initialIndexPath = nil
              My.cellSnapshot = nil
            }
          })
        }
      }
    }
  
  func addFriendToItem(_ itemCell: ItemTableViewCell, _ friendCell: FriendCollectionViewCell) {
    if !itemCell.listOfFriends.contains(friendCell.friend!) {
      itemCell.listOfFriends.append(friendCell.friend!)
      itemFriendsMap[itemCell.itemNameLabel.text!]?.append(friendCell.friend!)
      friendItemsMap[(friendCell.friend?.userName)!]?.append(itemCell.item!)
    }
    var index = 0
    for friend in itemCell.listOfFriends {
      let image = UIImage(named: friend.profileImageName!)
      let imageView = UIImageView(image: image)
      let xPosition = 24 + 40 * index
      imageView.frame = CGRect(x: xPosition, y: 36, width: 30, height: 30)
      itemCell.addSubview(imageView)
      index += 1
    }
  }
  
  func snapshotOfCell(_ imageName: String) -> UIView {
    let inputView = UIImageView(image: UIImage(named: imageName))
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
    inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    let cellSnapshot : UIView = UIImageView(image: image)
    cellSnapshot.layer.masksToBounds = false
    cellSnapshot.layer.cornerRadius = 0.0
    cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
    cellSnapshot.layer.shadowRadius = 5.0
    cellSnapshot.layer.shadowOpacity = 0.4
    return cellSnapshot
  }
  
  func calculateSnapShotLocation(_ friendCell: FriendCollectionViewCell, _ locationInTableView: CGPoint) -> CGPoint {
    var resultCenter = CGPoint()
    resultCenter.x = locationInTableView.x
    resultCenter.y = locationInTableView.y + friendCell.profileImageView.frame.size.height/2
    return resultCenter
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNextButton()
        itemFriendBindingDataSourceDelegate = ItemFriendBindingDataSourceDelegate(itemFriendBindingVC: self)
        itemListTableView.estimatedRowHeight = 60
        itemListTableView.rowHeight = UITableViewAutomaticDimension
    }
  
    func setupNextButton() {
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonClicked))
    }
  
    func nextButtonClicked() {
      // Validating to make sure all the items are taken
      if validateData() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let reviewViewController = storyBoard.instantiateViewController(withIdentifier: "reviewPage") as! ReviewViewController
        reviewViewController.itemFriendsMap = itemFriendsMap
        reviewViewController.friendItemsMap = friendItemsMap
        reviewViewController.selectedFriends = selectedFriends
        self.show(reviewViewController, sender: self)
      }
    }
  
    func validateData() -> Bool {
      for (_, friends) in itemFriendsMap {
        if friends.isEmpty {
          let alertController = UIAlertController(title: "Something is missing", message:
            "Please make sure all the items are binded with at least one friend", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
          
          self.present(alertController, animated: true, completion: nil)
          return false
        }
      }
      return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
