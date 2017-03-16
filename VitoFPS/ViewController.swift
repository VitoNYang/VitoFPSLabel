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
        
        guard let navigationView = navigationController?.view else {
            return
        }
        let label = VitoFPSLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        navigationView.addSubview(label)
        label.topAnchor.constraint(equalTo: navigationView.topAnchor, constant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor).isActive = true
        
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
