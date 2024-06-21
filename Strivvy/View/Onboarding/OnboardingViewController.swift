//
//  OnboardingViewController.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 21/06/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private var onboardingView = OnboardingView()
    
    override func loadView() {
        view = onboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

