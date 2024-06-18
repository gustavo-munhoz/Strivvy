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
            sheet.delegate = self
        }
        
        self.present(navController, animated: true, completion: nil)
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
        handleCellAppearance(cell: cell, cellState: cellState, date: date)
        
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
    
    private func handleCellAppearance(cell: CalendarCell, cellState: CellState, date: Date) {
        cell.backgroundColor = .clear
        cell.contentView.alpha = cellState.dateBelongsTo == .thisMonth ? 1 : 0.5
    
        if hasRecord(for: date) {
            // height and width are not equal. Would be nice to have 1:1, with vertical spacing instead of tall cels
            cell.backgroundColor = .systemBlue
            cell.layer.cornerRadius = min(cell.frame.size.width, cell.frame.size.height) / 2
            cell.clipsToBounds = true
            cell.layer.masksToBounds = true
        } else {
            cell.layer.cornerRadius = 0
        }
    }
}

extension CalendarViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if let selectedDetentIdentifier = sheetPresentationController.selectedDetentIdentifier,
           let navigationController = sheetPresentationController.presentedViewController as? UINavigationController {            
            if let view = navigationController.topViewController?.view as? DayRecordView {
                view.adjustSizeForIdentifier(selectedDetentIdentifier)
            }
        }
    }
}

extension CalendarViewController {
    func hasRecord(for date: Date) -> Bool {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: date)

        let photoPath = documentsDirectory.appendingPathComponent("\(dateString)-photo.jpg").path
        let weightPath = documentsDirectory.appendingPathComponent("\(dateString)-weight.txt").path
                
        return fileManager.fileExists(atPath: photoPath) || fileManager.fileExists(atPath: weightPath)
    }
}
