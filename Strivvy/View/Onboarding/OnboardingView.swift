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
        
        view.font = .init(descriptor: customFd, size: 0)
        view.textColor = .primary
        
        return view
    }()
    
    private(set) lazy var cellStackView: UIStackView = {
        let cells = createOnboardingCells()
        let view = UIStackView(arrangedSubviews: cells)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.spacing = 24
        view.axis = .vertical
        view.alignment = .center
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createOnboardingCells() -> [OnboardingCell] {
        return []
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(cellStackView)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeAreaLayoutGuide)
        }
        
        cellStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
        }
    }
}
