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
            setupBasedInputAllowance()
        }
    }
    
    private var isEditingWeight = false
    
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageViewOrAddPhoto))
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(imageView)
        
        return view
    }()
    
    private lazy var weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizedString.weightLabel
        textField.font = .preferredFont(forTextStyle: .title3)
        textField.textAlignment = .center
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "camera.shutter.button.fill")?.withTintColor(.primary, renderingMode: .alwaysOriginal)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private(set) lazy var addPhotoButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray
        config.baseForegroundColor = .primary
        
        let button = UIButton(configuration: config)
        button.setTitle("Add Photo", for: .normal)
        button.addTarget(self, action: #selector(didTapImageViewOrAddPhoto), for: .touchUpInside)
        
        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        return button
    }()

    private lazy var addWeightButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemGray
        config.baseForegroundColor = .primary
        
        let button = UIButton(configuration: config)
        button.setTitle("Add Weight", for: .normal)
        button.addTarget(self, action: #selector(didTapAddWeight), for: .touchUpInside)

        button.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        return button
    }()
    
    private(set) lazy var buttonsStackView: UIStackView = {
        let view = UIStackView(
            arrangedSubviews: [
                UIView.spacer(for: .vertical),
                addPhotoButton,
                addWeightButton
            ]
        )
        
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 20
        
        view.alpha = 0
        
        return view
    }()
    
    var onAddPhotoTap: (() -> Void)?
    var onAddWeightTap: (() -> Void)?
    
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
            .receive(on: RunLoop.main)
            .sink{ [weak self] image in
                self?.updateImage(
                    image
                    ?? UIImage(systemName: "camera.shutter.button.fill")!
                        .withTintColor(.primary, renderingMode: .alwaysOriginal))
            }
            .store(in: &cancellables)
        
        viewModel?.weightPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] weight in
                self?.updateWeight(weight)
            }
            .store(in: &cancellables)
    }
    
    private func setupBasedInputAllowance() {
        guard let viewModel = viewModel else { return }
        
        if !viewModel.allowsUserInput {
            weightTextField.isEnabled = false
            weightTextField.placeholder = ""
        }
    }
    
    private func setupView() {
        addSubview(dateLabel)
        addSubview(imageContainerView)
        addSubview(weightTextField)
        addSubview(buttonsStackView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(imageContainerView.snp.height).priority(.high)
            make.width.lessThanOrEqualToSuperview().inset(24).priority(.required)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(imageContainerView.snp.bottom).priority(.required)
            make.centerX.equalTo(safeAreaLayoutGuide).priority(.required)
            make.height.greaterThanOrEqualTo(120).priority(.required)
            make.bottom.equalTo(safeAreaLayoutGuide).priority(.high)
            make.width.equalToSuperview().inset(24)
        }
    }
    
    func adjustSizeForIdentifier(_ identifier: UISheetPresentationController.Detent.Identifier) {
        imageContainerView.snp.removeConstraints()
        
        switch identifier {
            case .medium:
                UIView.animate(withDuration: 0.1) {
                    self.buttonsStackView.alpha = 0
                }
                
                UIView.animate(withDuration: 0.3) {
                    
                    self.imageContainerView.snp.makeConstraints { make in
                        make.top.equalTo(self.weightTextField.snp.bottom).offset(20)
                        make.bottom.equalTo(self.safeAreaLayoutGuide).inset(40)
                        make.width.equalTo(self.imageContainerView.snp.height).priority(.high)
                        make.width.lessThanOrEqualToSuperview().inset(24).priority(.required)
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
                        make.top.equalTo(self.weightTextField.snp.bottom).offset(20)
                        make.leading.trailing.equalToSuperview().inset(24)
                        make.height.equalTo(self.imageContainerView.snp.width)
                    }
                    
                    self.imageView.snp.remakeConstraints { make in
                        make.center.equalToSuperview()
                        make.width.height.equalToSuperview()
                    }
                 
                    self.layoutIfNeeded()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    UIView.animate(withDuration: 0.05) {
                        self.buttonsStackView.alpha = 1
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
    
    @objc private func didTapImageViewOrAddPhoto() {
        guard !isEditingWeight else {
            dismissKeyboard()
            return
        }
        
        onAddPhotoTap?()
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc private func didTapAddWeight() {
        weightTextField.becomeFirstResponder()
    }

    private func updateImage(_ image: UIImage) {
        imageView.image = image
    }
    
    private func updateWeight(_ weight: String?) {
        weightTextField.text = weight
    }
}

extension DayRecordView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 10
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditingWeight = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEditingWeight = false
        
        if let text = textField.text {
            viewModel?.updateWeight(text)
        }
    }
}
