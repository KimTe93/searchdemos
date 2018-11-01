//
//  ColorCorrectionVC.swift
//  searchdemo
//
//  Created by thianluankim on 10/18/18.
//  Copyright © 2018 thianluankim. All rights reserved.
//

import UIKit

class ColorCorrectionVC: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    
       var colors = ["None", "Deuteranomaly (red-green)", "Protanomaly (red-green)", "Tritanomaly (blue-yellow)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
     
    }
}


extension ColorCorrectionVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return colors.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = colors[indexPath.row]
        return cell
    }
}













