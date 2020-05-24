//
//  stripeStartViewController.swift
//  learning_firebase_onboarding
//
//  Created by Charles Oxendine on 5/24/20.
//  Copyright © 2020 Charles Oxendine. All rights reserved.
import UIKit

class stripeStartViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var goToOnboardingButton: UIButton!
    @IBOutlet weak var promptText: UILabel!
    
    var accountLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goToOnboardingButton.isEnabled = false
        
        setUI()
        createStripeAccount()
    }
    
    func setUI() {
        self.goToOnboardingButton.layer.cornerRadius = 15
    }
    
    func createStripeAccount() {
        activityIndicator.startAnimating()
        cloudFunctions.createStripeConnectAccount(uid: userServices.shared.uid) { (accountID, err) in
            if err != nil {
                alerts.ok_alert(viewController: self, title: "Error creating stripe account", message: err!)
            }
            
            guard accountID != nil else {
                return
            }
            
            cloudFunctions.createAccountLink(accountID: accountID!) { (urlString, err) in
                if err != nil {
                    alerts.ok_alert(viewController: self, title: "Error creating stripe account", message: err!)
                }
                
                self.accountLink = urlString
                self.activityIndicator.stopAnimating()
                self.goToOnboardingButton.isEnabled = true
            }
        }
    }
    
    @IBAction func goToOnBoardingTapped(_ sender: Any) {
        if let url = URL(string: self.accountLink!) {
            UIApplication.shared.open(url)
        }
    }
}
