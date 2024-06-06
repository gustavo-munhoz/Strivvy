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
        calendarView.calendarView.register(
            CalendarHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: CalendarHeaderView.self)
        )
    }
    
    private func presentDayRecordView(for date: Date) {
        logger.debug("Presenting sheet for date: \(date)")
        
        let viewController = DayRecordViewController(viewModel: DayRecordViewModel(date: date))
        
        viewController.navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeSheet)
        )
        
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.modalPresentationStyle = .pageSheet
        if let sheet = navController.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]            
        }
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc func closeSheet() {
        self.dismiss(animated: true)
    }
}

extension CalendarViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        // TODO: Depois de pronto, arrumar as datas iniciais
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .month, value: 3, to: startDate)!
        
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            generateInDates: .forAllMonths,
            generateOutDates: .off,
            firstDayOfWeek: .sunday,
            hasStrictBoundaries: true            
        )
    }
}

extension CalendarViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, willDisplay cell: JTAppleCalendar.JTACDayCell, forItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) {
        return
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        presentDayRecordView(for: date)
    }
    
    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, cellForItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) -> JTAppleCalendar.JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(
            withReuseIdentifier: String(describing: CalendarCell.self),
            for: indexPath
        ) as! CalendarCell
        
        cell.configure(with: cellState.text)
        handleCellAppearance(cell: cell, cellState: cellState)
        
        return cell
    }        
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(
            withReuseIdentifier: String(describing: CalendarHeaderView.self),
            for: indexPath
        ) as! CalendarHeaderView
        
        header.configure(with: range.start)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 75)
    }
    
    private func handleCellAppearance(cell: CalendarCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.contentView.alpha = 1.0
        } else {
            cell.contentView.alpha = 0.5
        }
    }
}
