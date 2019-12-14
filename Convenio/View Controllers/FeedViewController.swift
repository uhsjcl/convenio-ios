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
        let cell = tableView.dequeueReusableCell(withIdentifier: "LongEventCell", for: indexPath) as! FeedLongEventCell
        let e = Event()
        e.title = "Scavenger Hunt"
        e.description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam."
        cell.setup(event: e)
        return cell
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
