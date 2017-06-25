//
//  ActivityDataSource.swift
//  DineOut
//
//  Created by Zhang, Xiaolong on 6/18/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class ActivityDataSource: NSObject {
    
    private weak var activityViewController: ActivityViewController?
    fileprivate var activityViewModel: ActivityViewModel
    
    init(activityVC: ActivityViewController) {
        self.activityViewController = activityVC
        self.activityViewModel = ActivityViewModel()
    }
}

extension ActivityDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityTableCell
        let activity = activityViewModel.activity(withIndex: indexPath.row)
        cell.profileImageView.image = UIImage(named: activity.sender.profileImageName!)
        cell.paymentMsgLabel.text = activity.paymentMessage
        cell.timeToDateLabel.text = activity.activityToDate
        cell.paymentInfoLabel.text = "\(activity.sender.firstName) \(activity.sender.lastName) paid \(activity.receiver.firstName) \(activity.receiver.lastName)"
        cell.favNumberLabel.text = "\(activity.numberOfLikes)"
        cell.commentNumberLabel.text = "\(activity.numberOfComments)"
        if activity.numberOfComments > 0 {
            cell.commentImageView.image = UIImage(named: "ic_comment_active")
        } else {
            cell.commentImageView.image = UIImage(named: "ic_comment_default")
        }
        if activity.numberOfLikes > 0 {
            cell.favImageView.image = UIImage(named: "ic_like_active_20")
        } else {
            cell.favImageView.image = UIImage(named: "ic_like_default")
        }
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityViewModel.numberOfRowInSection()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activityViewModel.numberOfSection()
    }
    
    
}
