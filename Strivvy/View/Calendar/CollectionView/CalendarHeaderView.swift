//
//  CalendarHeaderView.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 05/06/24.
//

import UIKit
import SnapKit
import JTAppleCalendar

class CalendarHeaderView: JTACMonthReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false    
        label.textColor = .primary        
        let fd = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
        
        let customFd = fd.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold
            ]
        ])
        
        label.font = UIFont(descriptor: customFd, size: 0)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        titleLabel.text = dateFormatter.string(from: date)
    }
}
