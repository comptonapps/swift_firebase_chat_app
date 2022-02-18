//
//  AlertService.swift
//  Section4-8ChatApp
//
//  Created by Jonathan Compton on 7/6/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

enum AuthErrorType: String {
    case emailAlreadyInUse = "emailAlreadyInUse"
    case invalidEmail = "invalidEmail"
    case wrongPassword = "wrongPassword"
    case emailNotFound = "emailNotFound"
    case emptyField = "emptyField"
}



import Foundation
import UIKit

class AlertService {
    
    private init(){}
    static let shared = AlertService()
    
    func getEnumAlert(type: AuthErrorType) -> UIAlertController {
        let alertMessage = NSLocalizedString(type.rawValue, comment: "This key gets the localized string value")
        let ac = UIAlertController(title: "ChatPal", message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(action)
        return ac
    }
    
    func getLocalizedAlert(error: Error) -> UIAlertController {
        let ac = UIAlertController(title: "ChatPal", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(action)
        return ac
    }
        
        
}
