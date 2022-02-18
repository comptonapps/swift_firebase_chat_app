//
//  ViewController.swift
//  Section4-8ChatApp
//
//  Created by Jonathan Compton on 7/5/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ChatMaster4.8"
        dateLabel.text = getFormattedDate()
    }
    
    func getFormattedDate() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let year = calendar.component(.year, from: currentDate)
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        let date = calendar.date(from: components)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date!)

    }



}

