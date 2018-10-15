//
//  BrightnessVC.swift
//  searchdemo
//
//  Created by thianluankim on 10/13/18.
//  Copyright © 2018 thianluankim. All rights reserved.
//

import UIKit

class BrightnessVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    @IBAction func sliderChanges(_ sender: UISlider) {
    UIScreen.main.brightness = CGFloat(sender.value)
        
    }
    
   
}










