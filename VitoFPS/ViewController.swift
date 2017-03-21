//
//  ViewController.swift
//  VitoFPS
//
//  Created by hao on 2017/3/13.
//  Copyright © 2017年 Vito. All rights reserved.
//

import UIKit
import VitoFPSLabel

class DemoViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func hiddenFPSWindow(sender: UIButton) {
         VitoFPSManager.shared.hidden()
    }
    
    @IBAction func showFPSWindow(sender: UIButton) {
        VitoFPSManager.shared.show()
    }
    
    @IBAction func toggleDragAction(_ sender: UIButton) {
        VitoFPSManager.shared.needDrag = !VitoFPSManager.shared.needDrag
    }
    
    // MARK: -UITableViewData Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 180
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: DemoCell.cellIdentifier) as! DemoCell

        return cell
    }

}

class DemoCell: UITableViewCell {
    static let cellIdentifier = "DemoCell"
}
