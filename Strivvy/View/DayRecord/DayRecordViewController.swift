//
//  DayRecordViewController.swift
//  Strivvy
//
//  Created by Gustavo Munhoz Correa on 05/06/24.
//

import Foundation
import UIKit

class DayRecordViewController: UIViewController {
    
    let date: Date
    
    private lazy var dayRecordView = DayRecordView(date: date)
    
    init(date: Date) {
        self.date = date
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
        
        
    }
}

