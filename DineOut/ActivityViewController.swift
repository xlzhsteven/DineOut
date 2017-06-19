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
    override func viewDidLoad() {
        super.viewDidLoad()
        activityViewDataSource = ActivityDataSource(activityVC: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var activityViewDataSource: ActivityDataSource? {
        didSet {
            if let dataSource = self.activityViewDataSource {
                self.activityTable.dataSource = dataSource
            }
        }
    }
    
}

