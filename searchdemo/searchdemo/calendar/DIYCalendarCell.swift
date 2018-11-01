//
//  DIYCalendarCell.swift
//  searchdemo
//
//  Created by thianluankim on 10/15/18.
//  Copyright © 2018 thianluankim. All rights reserved.
//

import Foundation
import FSCalendar


enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class DIYCalendarCell: FSCalendarCell {
    
    weak var todayView:UIView!
    weak var todayLayer:CAShapeLayer!
    weak var selectionLayer: CAShapeLayer!
    weak var mainSelectionLayer: CAShapeLayer!
   
    
    var activeColor:CGColor!
    var inactiveColor:CGColor!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //MARK:setup today layer
        let todayView = UIView()
        self.contentView.insertSubview(todayView, at: 0)
        self.todayView = todayView
        
        let todayLayer = CAShapeLayer()
        todayLayer.fillColor = UIColor.black.cgColor
        self.todayView.layer.insertSublayer(todayLayer, below: self.titleLabel!.layer)
        self.todayLayer = todayLayer
        
        //MARK:setup selection layer
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.white.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        let mainSelectionLayer = CAShapeLayer()
        mainSelectionLayer.fillColor = UIColor.white.cgColor
        mainSelectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(mainSelectionLayer, below: self.selectionLayer)
        self.mainSelectionLayer = mainSelectionLayer
        
        self.shapeLayer.isHidden = true
        let view = UIView(frame: self.bounds)
        activeColor = hexStringToUIColor(hex: "#008FBA").cgColor
        inactiveColor = hexStringToUIColor(hex: "#99C9D7").cgColor
        self.backgroundView = view;
        
        //MARK: toast
      
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //MARK: TODAY view
        self.todayView.frame = self.contentView.bounds
        self.todayLayer.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 30)
        let diameter: CGFloat = min(self.todayLayer.frame.height, self.todayLayer.frame.width)
        self.todayLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.todayLayer.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        
        //MARK: selection view
        selectionLayer.fillColor = activeColor
        mainSelectionLayer.fillColor = inactiveColor
        
        
        self.mainSelectionLayer.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 30)
        self.selectionLayer.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 30)
        
        
        let diameter1: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
        self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter1 / 2, y: self.contentView.frame.height / 2 - diameter1 / 2, width: diameter1, height: diameter1)).cgPath
        
        let diameter2: CGFloat = min(self.mainSelectionLayer.frame.height, self.mainSelectionLayer.frame.width)
        self.mainSelectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter2 / 2, y: self.contentView.frame.height / 2 - diameter2 / 2, width: diameter2, height: diameter2)).cgPath
        
        
        
        if selectionType == .middle {
            selectionLayer.fillColor = inactiveColor
            mainSelectionLayer.fillColor = inactiveColor
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
            self.mainSelectionLayer.path = UIBezierPath(rect: self.mainSelectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            
            
            //MARK: start date circle
            selectionLayer.fillColor = activeColor
            let diameter1: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter1 / 2, y: self.selectionLayer.frame.height / 2 - diameter1 / 2, width: diameter1, height: diameter1)).cgPath
            
            
            //for main layout
            mainSelectionLayer.fillColor = inactiveColor
            self.mainSelectionLayer.path = UIBezierPath(roundedRect: CGRect(x: self.mainSelectionLayer.frame.width / 2 - diameter1 / 2, y: 0, width: self.mainSelectionLayer.frame.width, height: self.mainSelectionLayer.frame.height), byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.mainSelectionLayer.frame.width / 2, height: self.mainSelectionLayer.frame.width / 2 )).cgPath
            
        }
        else if selectionType == .rightBorder {
            selectionLayer.fillColor = activeColor
            
            //MARK: start date circle
            let diameter1: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter1 / 2, y: self.selectionLayer.frame.height / 2 - diameter1 / 2, width: diameter1, height: diameter1)).cgPath
            
            //for main layout
            mainSelectionLayer.fillColor = inactiveColor
            self.mainSelectionLayer.path = UIBezierPath(roundedRect: CGRect(x: self.mainSelectionLayer.frame.width / 2 - diameter1 * 1.5 , y: 0, width: self.mainSelectionLayer.frame.width, height: self.mainSelectionLayer.frame.height), byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.mainSelectionLayer.frame.width / 2, height: self.mainSelectionLayer.frame.width / 2 )).cgPath
            
        }
        else if selectionType == .single {
            selectionLayer.fillColor = activeColor
            mainSelectionLayer.fillColor = activeColor
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.selectionLayer.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            
            self.mainSelectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.selectionLayer.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
}

