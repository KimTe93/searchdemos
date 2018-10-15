//
//  BrightnessVC.swift
//  searchdemo
//
//  Created by thianluankim on 10/13/18.
//  Copyright © 2018 thianluankim. All rights reserved.
//

import UIKit

class BrightnessVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var aCIImage = CIImage();
    var contrastFilter: CIFilter!;
    var brightnessFilter: CIFilter!;
    var context = CIContext();
    var outputImage = CIImage();
    var newUIImage = UIImage();
    
    @IBOutlet weak var qrImageView:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let aUIImage = qrImageView.image;
//        let aCGImage = aUIImage?.cgImage;
//        aCIImage = CIImage(cgImage: aCGImage!)
//        context = CIContext(options: nil);
//        contrastFilter = CIFilter(name: "CIColorControls");
//        contrastFilter.setValue(aCIImage, forKey: "inputImage")
//        brightnessFilter = CIFilter(name: "CIColorControls");
//        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
    }
    
    @IBAction func sliderContrastValueChanged(_ sender: UISlider) {
//        contrastFilter.setValue(NSNumber(value: sender.value), forKey: "inputContrast")
//                outputImage = contrastFilter.outputImage!;
//                let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
//                newUIImage = UIImage(cgImage: cgimg!)
//                qrImageView.image = newUIImage;
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
//        brightnessFilter.setValue(NSNumber(value: sender.value), forKey: "inputBrightness");
//        outputImage = brightnessFilter.outputImage!;
//        let imageRef = context.createCGImage(outputImage, from: outputImage.extent)
//        newUIImage = UIImage(cgImage: imageRef!)
//        qrImageView.image = newUIImage;
//
        UIScreen.main.brightness = CGFloat(sender.value)
    }
}












