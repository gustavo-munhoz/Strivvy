//
//  OnboardingCell.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 19/06/24.
//

import UIKit
import SnapKit

class OnboardingCell: UIView {
    
    private(set) lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let fd = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title3)
        
        let customFd = fd.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold
            ]
        ])
        
        view.font = .init(descriptor: customFd, size: 0)
        view.textColor = .primary
        
        return view
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let fd = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        
        let customFd = fd.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.weight: UIFont.Weight.regular
            ]
        ])
        
        return view
    }()
    
    private(set) lazy var textStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 12
        
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
    
    private func addSubviews() {
        addSubview(image)
        addSubview(textStackView)
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
        }
        
        textStackView.snp.makeConstraints { make in
            make.left.equalTo(image.snp.right).offset(12)
            make.top.bottom.right.equalToSuperview()
        }
    }
}

