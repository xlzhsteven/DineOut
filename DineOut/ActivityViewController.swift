//
//  ViewController.swift
//  DineOut
//
//  Created by Zhang, Xiaolong on 6/18/17.
//  Copyright © 2017 Zhang, Xiaolong. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var activityTable: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var additionalActivities: [Activity] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityViewDataSource = ActivityDataSource(activityVC: self, withAdditionalData: additionalActivities)
        activityTable.separatorStyle = .none
      activityTable.rowHeight = UITableView.automaticDimension
        activityTable.estimatedRowHeight = 110
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.21, green: 0.53, blue: 0.78, alpha: 1)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .default
    }

    var activityViewDataSource: ActivityDataSource? {
        didSet {
            if let dataSource = self.activityViewDataSource {
                self.activityTable.dataSource = dataSource
            }
        }
    }
    
}

