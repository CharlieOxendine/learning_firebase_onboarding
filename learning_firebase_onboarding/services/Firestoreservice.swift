//
//  Firestoreservice.swift
//  learning_firebase_onboarding
//
//  Created by Charles Oxendine on 5/24/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import Foundation
import Firebase

class Firestoreservice {
    
    static let db_base = Firestore.firestore()
    
    static func create_user_doc(vc: UIViewController, uid: String, user_data: [String : Any], completion: @escaping () -> ()) {
    
        db_base.collection("users").document(uid).setData(user_data) { (err) in
            if err != nil {
                print("Error Creating User Doc: \(err!.localizedDescription)")
                alerts.ok_alert(viewController: vc, title: "Error", message: err!.localizedDescription)
                return
            }
            
            completion()
        }
    }
}
