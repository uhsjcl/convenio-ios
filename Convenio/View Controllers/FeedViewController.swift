//
//  FeedViewController.swift
//  Convenio
//
//  Created by Anshay Saboo on 10/20/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import UIKit
import SideMenuSwift

class FeedViewController: UIViewController {

    @IBOutlet weak var tableBackground: UIView!
    @IBOutlet weak var feedTable: UITableView!
    
    var cells: [FeedCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // table setup
        feedTable.delegate = self
        feedTable.dataSource = self
        feedTable.rowHeight = UITableView.automaticDimension
        feedTable.estimatedRowHeight = 150
    }
    
    override func viewDidLayoutSubviews() {
        tableBackground.roundTopTwoCorners()
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        sideMenuController?.revealMenu()
    }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var id = ""
        switch indexPath.row {
        case 0:
            id = "EventCell"
        case 1:
            id = "InfoCell"
        case 2:
            id = "LongEventCell"
        case 3:
            id = "EventCell"
        default:
            id = "EventCell"
        }
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
    }
}

class FeedCell {
    var type: FeedCellType!
    var event: Event!
}

enum FeedCellType: String {
    case announcement = "announcement"
    case event = "event"
    case longEvent = "longEvent"
}
