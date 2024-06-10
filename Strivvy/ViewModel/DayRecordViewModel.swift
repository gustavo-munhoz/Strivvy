//
//  DayRecordViewModel.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 05/06/24.
//

import Foundation
import UIKit
import Combine
import os

class DayRecordViewModel {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "DayRecordViewModel")
    
    let date: Date
    private(set) var photo: UIImage?
    
    let imagePublisher = PassthroughSubject<UIImage?, Never>()
    
    init(date: Date) {
        self.date = date
    }
    
    func setup() {
        loadPhoto()
    }
    
    func updatePhoto(_ newPhoto: UIImage) {
        photo = newPhoto
        savePhoto(newPhoto)
        imagePublisher.send(photo)
    }
    
    private func documentDirectoryPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func filePath() -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let fileName = "\(dateFormatter.string(from: date)).jpg"
        return documentDirectoryPath().appendingPathComponent(fileName)
    }
    
    private func savePhoto(_ photo: UIImage) {
        guard let data = photo.jpegData(compressionQuality: 1.0) else { return }
        let path = filePath()
        
        logger.debug("Saving photo to path: \(path)")
        try? data.write(to: path)
    }
    
    private func loadPhoto() {
        let fileURL = filePath()
        logger.debug("Fetching photo for view in path: \(fileURL)")
        
        if let imageData = try? Data(contentsOf: fileURL),
           let image = UIImage(data: imageData) {
            self.photo = image
            imagePublisher.send(photo)
        }
    }
}

