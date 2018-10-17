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

// var calendar:FSCalendar!


class DIYCalendarCell: FSCalendarCell {
    
    //weak var circleImageView: UIImageView!
    weak var todayView:UIView!
    weak var selectionLayer: CAShapeLayer!
    weak var circleLayer:CAShapeLayer!
   
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
        let todayView = UIView()
        self.todayView = todayView
        self.contentView.insertSubview(todayView, at: 0)
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.orange.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.black.cgColor
        circleLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(circleLayer, below: self.titleLabel!.layer)
        self.circleLayer = circleLayer
        self.shapeLayer.isHidden = true
        let view = UIView(frame: self.bounds)
        //view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view;
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calendar.calendarWeekdayView.backgroundColor = UIColor.red.withAlphaComponent(0)
        calendar.calendarHeaderView.backgroundColor = UIColor.red
        //MARK: TODAY view
        self.todayView.frame = self.contentView.bounds
        
        let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
        self.circleLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
       self.todayView.layer.addSublayer(circleLayer)
      
        //MARK: selection view
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
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

