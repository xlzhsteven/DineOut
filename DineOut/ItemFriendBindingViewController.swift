//
//  ItemFriendBindingViewController.swift
//  DineOut
//
//  Created by Xiaolong Zhang on 7/2/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class ItemFriendBindingViewController: UIViewController {
    
    @IBOutlet weak var itemListTableView: UITableView!
    @IBOutlet weak var friendListCollectionView: UICollectionView!
    var selectedFriends: [String: Person]?
    
    var itemFriendBindingDataSourceDelegate: ItemFriendBindingDataSourceDelegate? {
        didSet {
            if let dataSourceDelegate = self.itemFriendBindingDataSourceDelegate {
                self.itemListTableView.dataSource = dataSourceDelegate
                self.itemListTableView.delegate = dataSourceDelegate
                self.friendListCollectionView.dataSource = dataSourceDelegate as? UICollectionViewDataSource
                self.friendListCollectionView.delegate = dataSourceDelegate as? UICollectionViewDelegate
                dataSourceDelegate.loadItemData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        itemFriendBindingDataSourceDelegate = ItemFriendBindingDataSourceDelegate(itemFriendBindingVC: self)
        itemListTableView.estimatedRowHeight = 60
        itemListTableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
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
