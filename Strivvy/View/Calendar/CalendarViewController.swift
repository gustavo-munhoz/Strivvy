//
//  CalendarViewController.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 03/06/24.
//

import UIKit
import JTAppleCalendar
import Combine
import os

class CalendarViewController: UIViewController {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: CalendarViewController.self))
    
    private var calendarView = CalendarView()
         
    override func loadView() {
        view = calendarView
    }
    
    weak var currentlyEditingCellViewModel: DayRecordViewModel? {
        didSet {
            bindDayRecordViewModel(currentlyEditingCellViewModel!)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendarView()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dayChanged),
            name: .NSCalendarDayChanged,
            object: nil
        )
        
        calendarView.calendarView.scrollToDate(Date(), animateScroll: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationItem.title = "Strivvy"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(
            image: UIImage(systemName: "questionmark.circle"),
            style: .done,
            target: self,
            action: #selector(presentOnboarding)
        )
        
        presentOnboardingIfNeeded()
    }
    
    @objc func dayChanged() {
        calendarView.calendarView.reloadData()
    }
    
    @objc func presentOnboarding() {
        self.present(OnboardingViewController(), animated: true)
    }
    
    private func presentOnboardingIfNeeded() {
        let defaults = UserDefaults.standard
        let hasShownOnboarding = defaults.bool(forKey: "hasShownOnboarding")
        
        if !hasShownOnboarding {
            presentOnboarding()
        }
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
        
        let vm = DayRecordViewModel(date: date)
        self.currentlyEditingCellViewModel = vm
        
        let viewController = DayRecordViewController(viewModel: vm)
        
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
    
    func showToast(message : String, seconds: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        self.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}

extension CalendarViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        guard let startDate = UserDefaults.standard.object(forKey: "FirstOpenDate") as? Date else {
            logger.error("First open date is not registered.")
            
            let startDate = Date()
            
            return ConfigurationParameters(
                startDate: startDate,
                endDate: Calendar.current.date(byAdding: .month, value: 3, to: startDate)!,
                generateInDates: .forAllMonths,
                generateOutDates: .off,
                firstDayOfWeek: .sunday,
                hasStrictBoundaries: true
            )
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
    
        let endDate = formatter.date(from: "2100 12 31")!
        
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
        if hasRecord(for: date) || Calendar.current.isDateInToday(date) { presentDayRecordView(for: date) }
        
        else {
            UIView.animate(withDuration: 0.125, animations: {
                cell?.backgroundColor = .primary.withAlphaComponent(0.4)
            }, completion: { [weak self] _ in
                UIView.animate(withDuration: 0.125) {
                    cell?.backgroundColor = .clear
                }
                                                
                self?.showToast(
                    message: date > Date() ? LocalizedString.invalidDateFuture : LocalizedString.invalidDateNoRegister,
                    seconds: 1.67
                )
            })
        }
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
        cell.contentView.alpha = (cellState.dateBelongsTo == .thisMonth && date <= Date()) ? 1 : 0.5
        cell.layer.cornerRadius = min(cell.frame.size.width, cell.frame.size.height) / 2 - 4
        cell.clipsToBounds = true
        cell.layer.masksToBounds = true
        
        if Calendar.current.isDateInToday(date) {
            cell.backgroundColor = .systemPurple
        }
        else {
            cell.backgroundColor = hasRecord(for: date) ? .systemTeal : .clear
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

extension CalendarViewController {
    
    func bindDayRecordViewModel(_ viewModel: DayRecordViewModel) {
        viewModel.changePublisher
            .receive(on: RunLoop.main)
            .sink {
                self.logger.debug("Received change from DayRecordViewModel.")
                self.calendarView.calendarView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func removeViewModelBinding() {
        self.currentlyEditingCellViewModel = nil
    }
}
