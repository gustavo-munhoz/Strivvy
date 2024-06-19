//
//  LocalizedString.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 04/06/24.
//

import Foundation

struct LocalizedString {
    static let weekDays: [String] = [
        String(localized: "Sunday"),
        String(localized: "Monday"),
        String(localized: "Tuesday"),
        String(localized: "Wednesday"),
        String(localized: "Thursday"),
        String(localized: "Friday"),
        String(localized: "Saturday"),        
    ]
    
    static let weightLabel = String(localized: "WeightLabel")
 
    static let settingsCameraTitle = String(localized: "OpenSettingsTitleCamera")
    static let settingsCameraMessage = String(localized: "OpenSettingsMessageCamera")
    static let settingsAlertTitle = String(localized: "OpenSettingsAlertTitle")
    
    static let chooseFromGallery = String(localized: "ChooseFromGallery")
    static let takePicture = String(localized: "TakePicture")
    static let chooseAnOption = String(localized: "ChooseAnOption")
    
    static let cancel = String(localized: "Cancel")
    
}
