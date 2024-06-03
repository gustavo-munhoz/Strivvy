//
//  HomeViewController.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 03/06/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var homeView = HomeView()
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

