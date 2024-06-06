//
//  DayRecordView.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 05/06/24.
//

import Foundation
import UIKit
import SnapKit

class DayRecordView: UIView {
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        let fd = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1)
        
        let customFd = fd.addingAttributes([
            .traits: [
                UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold
            ]
        ])
        
        label.font = UIFont(descriptor: customFd, size: .zero)
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Weight: -"
        return label
    }()
    
    var onImageTap: (() -> Void)?
    
    init(date: Date) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupView()
        setupConstraints()
        configure(with: date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(dateLabel)
        addSubview(imageView)
        addSubview(weightLabel)
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(imageView.snp.width)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func configure(with date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    @objc private func didTapImageView() {
        onImageTap?()
    }
    
    func updateImage(_ image: UIImage) {
        imageView.image = image
    }
}


