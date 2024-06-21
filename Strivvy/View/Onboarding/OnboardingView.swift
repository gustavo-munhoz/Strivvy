//
//  OnboardingView.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 19/06/24.
//

import UIKit
import SnapKit

class OnboardingView: UIView {
    
    var onContinueTap: (() -> Void)?
    
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
        config.baseBackgroundColor = .systemTeal
        config.attributedTitle = AttributedString(
            LocalizedString.continueTitle,
            attributes: AttributeContainer([
                .font: UIFont.preferredFont(forTextStyle: .body).withTraits(traits: .traitBold),
                .foregroundColor: UIColor.primary
            ])
        )
        
        let view = UIButton(configuration: config)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        return view
    }()
    
    @objc private func didTapContinue() {
        onContinueTap?()
    }
    
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
            image: UIImage(systemName: "archivebox.circle")!.withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        )
        
        let cell2 = OnboardingCell().withElements(
            title: LocalizedString.calendarTitle,
            description: LocalizedString.calendarDescription,
            image: UIImage(systemName: "calendar.circle")!.withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        )
        
        let cell3 = OnboardingCell().withElements(
            title: LocalizedString.notificationTitle,
            description: LocalizedString.notificationTescription,
            image: UIImage(systemName: "bell.circle")!.withTintColor(.systemTeal, renderingMode: .alwaysOriginal)
        )
        
        return [cell1, cell2, cell3]
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(cellStackView)
        addSubview(continueButton)
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
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(32).priority(.required)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(44)
        }
    }
}
