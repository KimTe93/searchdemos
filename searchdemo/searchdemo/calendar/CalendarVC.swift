//
//  CalendarVC.swift
//  searchdemo
//
//  Created by thianluankim on 10/15/18.
//  Copyright © 2018 thianluankim. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController {
    
    var monthFlag = false
    var localSelectedDateArray = [Date]()
    var selectedDateArray: [Date] = [] {
        didSet {
            
            selectedDateArray = calendar.selectedDates.sorted()
            //MARK:convert UTC date to local date cox UTC date is oneday smaller than local timezone
            localSelectedDateArray.removeAll()
            for d in selectedDateArray{
                let dDate = d.toLocalTime()
                localSelectedDateArray.append(dDate)
            }
            print("selectedDateArray \(selectedDateArray)")
            print("localSelectedDateArray \(localSelectedDateArray)")
            switch selectedDateArray.count {
            case 0:
                startDate = nil
                endDate = nil
            case 1:
                startDate = selectedDateArray.first
                endDate = nil
            case _ where selectedDateArray.count > 1:
                startDate = selectedDateArray.first
                endDate = selectedDateArray.last
                
                var nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startDate!)
                while (nextDay?.startOfDay)! <= endDate! {
                    calendar.select(nextDay)
                    nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay!)
                    
                }
            default:
                return
            }
        }
    }
    
    var startDate: Date? {
        didSet {
            startDate = startDate?.startOfDay
        }
    }
    
    var endDate: Date? {
        didSet {
            endDate = endDate?.endOfDay
        }
    }
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    @IBOutlet weak var calendarView: UIView!
    //@IBOutlet weak var calendar:FSCalendar!
    
    var calendar:FSCalendar!
    var activeColor:UIColor!
    
    private var currentPage: Date?
    var CURRENT_MONTH:String?
    var CURRENT_YEAR:String?
    var isShowToast:Bool = false
    
    private lazy var today: Date = {
        return Date()
    }()
    
    weak var toastLabel: UILabel!
    weak var downImage:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar = FSCalendar()
        calendar.frame = self.calendarView.bounds
        calendarView.addSubview(calendar)
        calendar.delegate = self
        calendar.dataSource = self
        calendar.clipsToBounds = true
        calendar.allowsMultipleSelection = true
        //        calendar.pagingEnabled = false
        calendar.scrollDirection = .horizontal
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.backgroundColor = .white
        calendar.placeholderType = .none
        calendar.today = nil // Hide the today circle
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
        //self.calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
        
        //        let dates = [
        //            self.gregorian.date(byAdding: .day, value: 1, to: Date())
        //        ]
        //        dates.forEach { (date) in
        //            self.calendar.select(date, scrollToDate: false)
        //        }
        
        // activeColor = hexStringToUIColor(hex: "#008FBA")
        
        
        
        self.calendar.appearance.headerTitleColor = UIColor.black
        self.calendar.appearance.weekdayTextColor = UIColor.black
        
        //self.calendar.calendarHeaderView.isHidden = true
        //self.calendar.calendarHeaderView.fs_month
        
        
        
        setupToast()
        
    }
    
    func setupToast(){
        //MARK: toast
        let toastLabel = UILabel()
        self.toastLabel = toastLabel
        toastLabel.frame = CGRect(x: self.view.frame.size.width/2 - 75, y:self.view.frame.size.height-100, width: 160, height: 60)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.layer.cornerRadius = 4;
        toastLabel.clipsToBounds  =  true
        
        toastLabel.numberOfLines = 2
        toastLabel.text = "Select another date for date range"
        toastLabel.backgroundColor = hexStringToUIColor(hex: "#008FBA")
        toastLabel.font = toastLabel.font.withSize(13)
        
        let image = UIImage(named: "down-arrow.png")
        let imageView = UIImageView(image: image!)
        self.downImage = imageView
        
        let diameter = min(toastLabel.frame.width, toastLabel.frame.height)
        downImage.frame = CGRect(x: toastLabel.center.x - diameter/2 , y: toastLabel.frame.maxY - 5, width: 20, height: 20)
        
        self.view.addSubview(toastLabel)
        self.view.addSubview(downImage)
        
        downImage.isHidden = false
        toastLabel.isHidden = false
    }
    
    
    
    @IBOutlet weak var btnPrevious: UIButton!
    
    @IBAction func previousMonth(_ sender: UIButton) {
        
        let currentDate = calendar.currentPage
        let currentDate1 = Calendar.current
        
        
        
        print(currentDate, currentDate1)
        //        if monthFlag == true{
        //           self.moveCurrentPage(moveUp: false)
        //            btnPrevious.setTitleColor(.blue, for: .normal)
        //        }else {
        //            btnPrevious.setTitleColor(.gray, for: .normal)
        //        }
        
    }
    
    
    @IBAction func nextMonth(_ sender: Any) {
        let currentDate = calendar.currentPage
        print(currentDate)
        monthFlag = true
        self.moveCurrentPage(moveUp: true)
        btnPrevious.setTitleColor(.blue, for: .normal)
    }
    
}

extension CalendarVC: FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    //MARK: hide past dates
    func minimumDate(for calendar: FSCalendar) -> Date { return Date() }
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if self.gregorian.isDateInToday(date) {
            return "T"
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.reloadInputViews()
        self.configure(cell: cell, for: date, at: position)
    }
    
    
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        // return monthPosition == .current
        let curDate = Date().addingTimeInterval(-24*60*60)
        if date < curDate {
            return false
        } else {
            return true
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
        //let currentMonth = calendar.month(of: calendar.currentPage)
        let currentMonth = calendar.month(of: calendar.currentPage)
        print("this is the current Month \(currentMonth)")
        let currentPage = calendar.currentPage;
        print(currentPage)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //        if date.isAfterDate(Date().endOfDay!) {
        //            calendar.deselect(date)
        //        } else {
        //            selectedDateArray.append(date)
        //            print(selectedDateArray)
        //        }
        
        selectedDateArray.append(date)
        self.configureVisibleCells()
        
        //        if isShowToast == true{
        //            toastLabel.isHidden = false
        //            downImage.isHidden = false
        //            isShowToast = false
        //        }else {
        //            toastLabel.isHidden = true
        //            downImage.isHidden = true
        //            isShowToast = true
        //        }
        
        
        
        let cell:FSCalendarCell = calendar.cell(for: date, at: monthPosition)!
        let frame = cell.frame
        let diameter = min(cell.frame.width, cell.frame.height)
        toastLabel.frame = CGRect(x: cell.center.x - 10, y: cell.frame.maxX, width: 160, height: 60)
        downImage.frame = CGRect(x: toastLabel.center.x - diameter/2 , y: toastLabel.frame.maxY - 5, width: 20, height: 20)
        
        print("cell frame \(frame)")
        print("toast frame \(toastLabel.frame)")
        

    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.selectedDates.count > 2 {
            let datesToDeselect: [Date] = calendar.selectedDates.filter{ $0 > date }
            datesToDeselect.forEach{ calendar.deselect($0) }
            calendar.select(date) // adds back the end date that was just deselected so it matches selectedDateArray
        }
        selectedDateArray = selectedDateArray.filter{ $0 < date }
        selectedDateArray.forEach{calendar.select($0)}
        self.configureVisibleCells()
        

    }
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        let diyCell = (cell as! DIYCalendarCell)
        //MARK:past dates color
        let curDate = Date().addingTimeInterval(-24*60*60)
        if date < curDate {
            diyCell.titleLabel.textColor = UIColor.lightGray
        }
        
        //MARK:custom today circle
        diyCell.todayView.isHidden = !self.gregorian.isDateInToday(date)
        
        //MARK:configure selection layer
        if position == .current {
            var selectionType = SelectionType.none
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                diyCell.mainSelectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.mainSelectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
            
        } else {
            diyCell.todayView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
    
    
    private func moveCurrentPage(moveUp: Bool) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        self.calendar.setCurrentPage(self.currentPage!, animated: true)
    }
}


extension Date {
    
    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }
    
    func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedAscending
    }
    
    func isAfterDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

