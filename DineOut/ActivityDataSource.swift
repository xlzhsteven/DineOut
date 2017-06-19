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
        let cell = UITableViewCell()
        cell.textLabel?.text = activityViewModel.activity(withIndex: indexPath.row).sender.firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityViewModel.numberOfRowInSection()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activityViewModel.numberOfSection()
    }
}
