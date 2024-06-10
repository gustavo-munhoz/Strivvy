//
//  DayRecordView.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 05/06/24.
//

import Foundation
import UIKit
import SnapKit
import Combine
import os

class DayRecordView: UIView {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "DayRecordView")
    
    private var cancellables = Set<AnyCancellable>()
    
    weak var viewModel: DayRecordViewModel? {
        didSet {
            setupSubscriptions()
        }
    }
    
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
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        // TODO: Implementar opção de tirar foto ou escolher da biblioteca
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(imageView)
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "camera.shutter.button.fill")?.withTintColor(.primary, renderingMode: .alwaysOriginal)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = LocalizedString.weightLabel
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
    
    private func setupSubscriptions() {
        logger.debug("Setting up DayRecordViewModel subscriptions.")
        
        viewModel?.imagePublisher
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] image in
                self?.updateImage(
                    image
                    ?? UIImage(systemName: "camera.shutter.button.fill")!
                        .withTintColor(.primary, renderingMode: .alwaysOriginal))
            }
            .store(in: &cancellables)
    }
    
    private func setupView() {
        addSubview(dateLabel)
        addSubview(imageContainerView)
        addSubview(weightLabel)
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.top.equalTo(weightLabel.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(imageContainerView.snp.height).priority(.high)
            make.width.lessThanOrEqualToSuperview().inset(12).priority(.required)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
    }
    
    func adjustSizeForIdentifier(_ identifier: UISheetPresentationController.Detent.Identifier) {
        imageContainerView.snp.removeConstraints()
        
        switch identifier {
            case .medium:
                UIView.animate(withDuration: 0.3) {
                    self.imageContainerView.snp.makeConstraints { make in
                        make.top.equalTo(self.weightLabel.snp.bottom).offset(20)
                        make.bottom.equalTo(self.safeAreaLayoutGuide).inset(40)
                        make.width.equalTo(self.imageContainerView.snp.height).priority(.high)
                        make.width.lessThanOrEqualToSuperview().inset(12).priority(.required)
                        make.centerX.equalToSuperview()
                    }
                    
                    self.imageView.snp.remakeConstraints { make in
                        make.center.equalToSuperview()
                        make.width.height.equalToSuperview()
                    }
                }
                
            case .large:
                UIView.animate(withDuration: 0.3) {
                    self.imageContainerView.snp.makeConstraints { make in
                        make.top.equalTo(self.weightLabel.snp.bottom).offset(20)
                        make.leading.trailing.equalToSuperview().inset(24)
                        make.height.equalTo(self.imageContainerView.snp.width)
                    }
                    
                    self.imageView.snp.remakeConstraints { make in
                        make.center.equalToSuperview()
                        make.width.height.equalToSuperview()
                    }
                }
                
            default:
                break
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
    
    private func updateImage(_ image: UIImage) {
        imageView.image = image
    }
}
