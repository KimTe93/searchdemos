//
//  ViewController.swift
//  searchdemo
//
//  Created by thianluankim on 10/12/18.
//  Copyright © 2018 thianluankim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    
    @IBAction func sharePressed(_ sender: UIButton) {
       let activityVC =  UIActivityViewController(activityItems: ["www.weeswares.com"], applicationActivities: nil)
        self.navigationController?.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func goToBrightness(_ sender: Any) {
        let vc = BrightnessVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}






