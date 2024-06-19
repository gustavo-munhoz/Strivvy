//
//  DayRecordViewController.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 05/06/24.
//

import Foundation
import UIKit
import AVFoundation

class DayRecordViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let viewModel: DayRecordViewModel
    
    private lazy var dayRecordView = DayRecordView(date: viewModel.date)
    
    init(viewModel: DayRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.dayRecordView.viewModel = viewModel
        self.viewModel.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = dayRecordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayRecordView.onAddPhotoTap = { [weak self] in
            self?.presentImagePicker()
        }
    }
    
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                self.openImagePicker(sourceType: .camera)
                
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        DispatchQueue.main.async {
                            self.openImagePicker(sourceType: .camera)
                        }
                    }
                }
                
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.promptToOpenSettings()
                }
                
            @unknown default:
                break
        }
    }
    
    private func presentImagePicker() {
        let alertController = UIAlertController(title: nil, message: LocalizedString.chooseAnOption, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: LocalizedString.takePicture, style: .default) { [weak self] _ in
                self?.checkCameraPermissions()
            }
            alertController.addAction(takePhotoAction)
        }

        let choosePhotoAction = UIAlertAction(title: LocalizedString.chooseFromGallery, style: .default) { [weak self] _ in
            self?.openImagePicker(sourceType: .photoLibrary)
        }
        alertController.addAction(choosePhotoAction)

        let cancelAction = UIAlertAction(title: LocalizedString.cancel, style: .cancel)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func promptToOpenSettings() {
        let alert = UIAlertController(
            title: LocalizedString.settingsAlertTitle,
            message: LocalizedString.settingsCameraMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: LocalizedString.settingsAlertTitle, style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        alert.addAction(UIAlertAction(title: LocalizedString.cancel, style: .cancel))
        present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
                
        if let selectedImage = info[.originalImage] as? UIImage {
            if picker.sourceType == .camera && picker.cameraDevice == .front {
                let mirroredImage = UIImage(cgImage: selectedImage.cgImage!, scale: selectedImage.scale, orientation: .leftMirrored)
                viewModel.updatePhoto(mirroredImage)
                
            } else {
                viewModel.updatePhoto(selectedImage)
            }
        }
    }

}

