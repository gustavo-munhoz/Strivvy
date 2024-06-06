//
//  DayRecordViewController.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 05/06/24.
//

import Foundation
import UIKit

class DayRecordViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let viewModel: DayRecordViewModel
    
    private lazy var dayRecordView = DayRecordView(date: viewModel.date)
    
    init(viewModel: DayRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = dayRecordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayRecordView.onImageTap = { [weak self] in
            self?.presentImagePicker()
        }
    }
    
    private func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.updatePhoto(selectedImage)
            dayRecordView.updateImage(selectedImage)
        }
    }
}

