//
//  OnboardingViewController.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 21/06/24.
//

import UIKit
import UserNotifications
import os

class OnboardingViewController: UIViewController {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: OnboardingViewController.self))
    
    private var onboardingView = OnboardingView()
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardingView.onContinueTap = requestNotificationPermission
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if granted {
                    self?.logger.info("User notifications permission granted.")
                    
                } else {
                    self?.logger.info("User notifications permission denied.")
                    
                }
                
                self?.dismiss(animated: true)
            }
        }
    }
}

