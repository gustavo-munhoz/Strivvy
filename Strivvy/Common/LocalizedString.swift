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
    static let addPicture = String(localized: "AddPicture")
    static let addWeight = String(localized: "AddWeight")
 
    static let settingsCameraTitle = String(localized: "OpenSettingsTitleCamera")
    static let settingsCameraMessage = String(localized: "OpenSettingsMessageCamera")
    static let settingsAlertTitle = String(localized: "OpenSettingsAlertTitle")
    
    static let chooseFromGallery = String(localized: "ChooseFromGallery")
    static let takePicture = String(localized: "TakePicture")
    static let chooseAnOption = String(localized: "ChooseAnOption")
    
    static let cancel = String(localized: "Cancel")
    static let continueTitle = String(localized: "Continue")
    
    static let welcome = String(localized: "Welcome")
    static let progressTitle = String(localized: "OnboardingProgressTitle")
    static let progressDescription = String(localized: "OnboardingProgressDescription")
    
    static let calendarTitle = String(localized: "OnboardingCalendarTitle")
    static let calendarDescription = String(localized: "OnboardingCalendarDescription")
    
    static let notificationTitle = String(localized: "OnboardingNotificationTitle")
    static let notificationTescription = String(localized: "OnboardingNotificationDescription")
    
    static let notificationReminderTitle = String(localized: "NotificationDailyReminderTitle")
    static let notificationReminderBody = String(localized: "NotificationDailyReminderBody")
    
    static let invalidDateNoRegister = String(localized: "InvalidDateNoRegister")
    static let invalidDateFuture = String(localized: "InvalidDateFuture")
}
