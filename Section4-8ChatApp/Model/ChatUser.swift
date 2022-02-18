//
//  ChatUser.swift
//  Section4-8ChatApp
//
//  Created by Jonathan Compton on 7/5/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import Foundation

class ChatUser {
    let id : String
    let name: String
    let email: String
    var selected: Bool
    
    init(id: String, name: String, email: String, selected: Bool) {
        self.id = id
        self.email = email
        self.name = name
        self.selected = selected
    }
}

