//
//  loginViewController.swift
//  learning_firebase_onboarding
//
//  Created by Charles Oxendine on 5/24/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.

import UIKit
import FirebaseAuth

class loginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setUI() {
        loginButton.layer.cornerRadius = 15
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard email != "" && email != nil else {
            alerts.ok_alert(viewController: self, title: "Error creating account", message: "Please fill in a valid email address")
            return
        }
    
        guard isPasswordValid(password!) == true else {
            alerts.ok_alert(viewController: self, title: "Error creating account", message: "Please fill in a valid password")
            return
        }
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (auth, err) in
            if err != nil {
                print("Error creating account: \(err!.localizedDescription)")
                alerts.ok_alert(viewController: self, title: "Error creating account", message: err!.localizedDescription)
                return
            }
            
            userServices.shared.loginUser(uid: (auth?.user.uid)!)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "stripe") as! stripeStartViewController
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true)
        }
    }
}
