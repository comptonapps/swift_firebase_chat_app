//
//  Message.swift
//  Section4-8ChatApp
//
//  Created by Jonathan Compton on 7/5/18.
//  Copyright © 2018 Jonathan Compton. All rights reserved.
//

import Foundation

class UserMessage {
    var senderID: String
    var time: Double
    var body: String
    var senderName: String
    
    init(senderID: String, time: Double, body: String, senderName: String) {
        self.senderID = senderID
        self.time = time
        self.body = body
        self.senderName = senderName
    }
}
