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

    var selectedDateArray: [Date] = [] {
        didSet {
            // sort the array
            selectedDateArray = calendar.selectedDates.sorted()
          
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
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        return formatter
    }()
  
    
    @IBOutlet weak var calendarView: UIView!
    //@IBOutlet weak var calendar:FSCalendar!
    
    
    var calendar:FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        calendar = FSCalendar()
        calendar.frame = self.calendarView.bounds
        calendarView.addSubview(calendar)
        calendar.delegate = self
        calendar.dataSource = self
        calendar.allowsMultipleSelection = true
        calendar.pagingEnabled = false
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        
        calendar.backgroundColor = .white
        calendar.placeholderType = .none
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
        calendar.scrollDirection = .vertical
        calendar.calendarWeekdayView.tintColor = UIColor.orange
        calendar.calendarHeaderView.tintColor = UIColor.orange
        //self.calendar.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
        let dates = [
            self.gregorian.date(byAdding: .day, value: 1, to: Date())
        ]
        dates.forEach { (date) in
            self.calendar.select(date, scrollToDate: false)
        }
        
    }
    
}

extension CalendarVC: FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if self.gregorian.isDateInToday(date) {
            return "Today"
        }
        return nil
    }
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    // MARK:- FSCalendarDelegate
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        // self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
//        return monthPosition == .current
//    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if date .compare(Date()) == .orderedAscending {
            
            return false
        }
        else {
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        if date.isAfterDate(Date().endOfDay!) {
//            calendar.deselect(date)
//        } else {
//            selectedDateArray.append(date)
//            print(selectedDateArray)
//        }
    
        let localDate = date.toLocalTime()
        print("selected date - \(date)")
        print("localDate - \(localDate)")
      
        selectedDateArray.append(localDate)
        self.configureVisibleCells()
        print(selectedDateArray)
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
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
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
        if date .compare(Date()) == .orderedAscending {
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
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            diyCell.todayView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
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





