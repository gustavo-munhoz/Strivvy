//
//  OnboardingView.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 19/06/24.
//

import UIKit
import SnapKit

class OnboardingView: UIView {
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let fd = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
        
        let customFd = fd.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold
            ]
        ])
        
        view.text = LocalizedString.welcome
        view.font = .init(descriptor: customFd, size: 0)
        view.textColor = .primary
        view.textAlignment = .center
        view.numberOfLines = 2
        view.lineBreakMode = .byWordWrapping
        
        return view
    }()
    
    private(set) lazy var cellStackView: UIStackView = {
        let cells = createOnboardingCells()
        let view = UIStackView(arrangedSubviews: cells)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.spacing = 36
        view.axis = .vertical
        view.alignment = .leading
        
        return view
    }()
    
    private(set) lazy var continueButton: UIButton = {
        var config = UIButton.Configuration.filled()
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createOnboardingCells() -> [OnboardingCell] {
        let cell1 = OnboardingCell().withElements(
            title: LocalizedString.progressTitle,
            description: LocalizedString.progressDescription,
            image: UIImage(systemName: "archivebox.circle")!
        )
        
        let cell2 = OnboardingCell().withElements(
            title: LocalizedString.calendarTitle,
            description: LocalizedString.calendarDescription,
            image: UIImage(systemName: "calendar.circle")!
        )
        
        let cell3 = OnboardingCell().withElements(
            title: LocalizedString.notificationTitle,
            description: LocalizedString.notificationTescription,
            image: UIImage(systemName: "bell.circle")!
        )
        
        return [cell1, cell2, cell3]
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(cellStackView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalTo(safeAreaLayoutGuide)
            make.top.equalToSuperview().inset(64)
        }
        
        cellStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(54)
            make.left.right.equalToSuperview().inset(32)
        }
    }
}
