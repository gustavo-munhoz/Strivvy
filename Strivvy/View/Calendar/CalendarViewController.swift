//
//  CalendarViewController.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 03/06/24.
//

import UIKit
import JTAppleCalendar
import os

class CalendarViewController: UIViewController {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: CalendarViewController.self))
    
    private var calendarView = CalendarView()
    
    override func loadView() {
        view = calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendarView()
    }
    
    private func configureCalendarView() {
        logger.debug("Configuring Calendar View...")
        
        calendarView.calendarView.calendarDataSource = self
        calendarView.calendarView.calendarDelegate = self
        calendarView.calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: String(describing: CalendarCell.self))
        
    }
}

extension CalendarViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendar.JTACMonthView) -> JTAppleCalendar.ConfigurationParameters {
        // TODO: Alterar depois de pronto
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .month, value: 3, to: startDate)!
        
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension CalendarViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, willDisplay cell: JTAppleCalendar.JTACDayCell, forItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) {
        return
    }
    
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, cellForItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) -> JTAppleCalendar.JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(
            withReuseIdentifier: String(describing: CalendarCell.self),
            for: indexPath
        ) as! CalendarCell
        
        cell.configure(with: cellState.text)
        
        logger.debug("Setup CalendarCell for item: \(indexPath.item)")
        
        return cell
    }
}
