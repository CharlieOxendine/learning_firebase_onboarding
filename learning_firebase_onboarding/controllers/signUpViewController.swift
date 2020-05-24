//
//  signUpViewController.swift
//  learning_firebase_onboarding
//
//  Created by Charles Oxendine on 5/24/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
//

import UIKit
import FirebaseAuth

class signUpViewController: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var verifyPasswordField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        self.createAccountButton.layer.cornerRadius = 15
    }
    
    func validateFields() -> String? {
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordVerify = verifyPasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userName = userNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard userName != "" && userName != nil else {
            return "Please fill in a user name"
        }
        
        guard email != "" && email != nil else {
            return "Please fill in a valid email address"
        }
        
        guard isPasswordValid(password!) == true else {
            return "Please fill in a valid password"
        }
        
        guard passwordVerify == password else {
            return "Your password don't match!"
        }
        
        return nil
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userName = userNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            
        guard validateFields() == nil else {
            alerts.ok_alert(viewController: self, title: "Error creating account", message: validateFields()!)
            return
        }
        
        Auth.auth().createUser(withEmail: email!, password: password!) { (auth, err) in
            if err != nil {
                print("Error creating account: \(err!.localizedDescription)")
                alerts.ok_alert(viewController: self, title: "Error creating account", message: err!.localizedDescription)
                return
            }
                
            let user_data: [String: Any] = ["username": userName!, "email": email!, "uid": auth!.user.uid]
            
            Firestoreservice.create_user_doc(vc: self, uid: (auth?.user.uid)!, user_data: user_data) {
                userServices.shared.loginUser(uid: (auth?.user.uid)!)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newVC = storyboard.instantiateViewController(withIdentifier: "stripe") as! stripeStartViewController
                newVC.modalPresentationStyle = .fullScreen
                self.present(newVC, animated: true)
            }
        }
    }
}
