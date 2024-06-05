//
//  CalendarCell.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 03/06/24.
//

import UIKit
import JTAppleCalendar
import SnapKit


class CalendarCell: JTACDayCell {
    
    private(set) lazy var dayLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.textColor = .primary
        
        view.font = .preferredFont(forTextStyle: .body)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()            
        }
    }
    
    func configure(with dayText: String) {
        dayLabel.text = dayText
    }
}
