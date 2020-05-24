//
//  userServices.swift
//  learning_firebase_onboarding
//
//  Created by Charles Oxendine on 5/24/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import Foundation

class userServices {
    
    var uid: String!
    
    static var shared = userServices()
    
    func loginUser(uid: String) {
        self.uid = uid
    }
}
