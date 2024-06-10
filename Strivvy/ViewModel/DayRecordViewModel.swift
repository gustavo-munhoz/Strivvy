//
//  DayRecordViewModel.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 05/06/24.
//

import Foundation
import UIKit
import Combine

class DayRecordViewModel {
    let date: Date
    private(set) var photo: UIImage?
    
    let imagePublisher = PassthroughSubject<UIImage?, Never>()
    
    init(date: Date) {
        self.date = date
    }
    
    func updatePhoto(_ newPhoto: UIImage) {
        photo = newPhoto
        imagePublisher.send(photo)
    }
}
