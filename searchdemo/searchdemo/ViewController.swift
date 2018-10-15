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

    
    @IBAction func calendarPressed(_ sender: UIButton) {
        let vc = CalendarVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func sharePressed(_ sender: UIButton) {
        let shareContent = "Let me share you something ..." + "\n" + "www.weeswares.com"
        print(shareContent)
       let activityVC =  UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        self.navigationController?.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func goToBrightness(_ sender: Any) {
        let vc = BrightnessVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}






