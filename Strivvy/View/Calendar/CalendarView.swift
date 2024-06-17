//
//  CalendarView.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 03/06/24.
//

import UIKit
import JTAppleCalendar
import SnapKit

class CalendarView: UIView {
    
    private(set) lazy var weekDaysView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    private(set) lazy var calendarView: JTACMonthView = {
        let view = JTACMonthView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        setupWeekDays()
        setupCalendar()
        
        self.backgroundColor = .systemBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(weekDaysView)
        addSubview(calendarView)
    }
    
    private func setupConstraints() {
        weekDaysView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(weekDaysView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func setupCalendar() {
        calendarView.scrollDirection = .vertical
        calendarView.scrollingMode = .stopAtEachSection
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.showsVerticalScrollIndicator = false
        calendarView.allowsSelection = true
        calendarView.cellSize = 75
    }
    
    private func setupWeekDays() {
        let weekDays = LocalizedString.weekDays
        for (index, day) in weekDays.enumerated() {
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            weekDaysView.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(weekDaysView).dividedBy(7)
                if index == 0 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(weekDaysView.subviews[index - 1].snp.trailing)
                }
            }
        }
    }
}

