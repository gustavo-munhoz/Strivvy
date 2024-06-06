//
//  DayRecordViewModel.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 05/06/24.
//

import Foundation
import UIKit

class DayRecordViewModel {
    let date: Date
    private(set) var photo: UIImage?
    
    init(date: Date) {
        self.date = date
    }
    
    func updatePhoto(_ newPhoto: UIImage) {
        photo = newPhoto
    }
}
