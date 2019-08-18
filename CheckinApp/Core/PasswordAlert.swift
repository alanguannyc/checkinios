//
//  PasswordAlert.swift
//  CheckinApp
//
//  Created by Alan Guan on 8/17/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import Foundation
import UIKit

class PasswordAlert {
    var alertTitle : String
    var alertMessage: String?
    
    var userInputValue : String?
    
    init(alertTitle: String, alertMessage: String?) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
    }
    
    var cancel : UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
    }
    
    func showWarning(view: UIViewController, actionHandler: ((Bool) -> Void)?){
        
        let dialog = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler:  {(action)-> Void in
            actionHandler?(true)
        })
        
        dialog.addAction(ok)
        dialog.addAction(cancel)
        view.present(dialog, animated: true)
    }
    
    
    func askForPasscode(view: UIViewController,  cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil, actionHandler: ((_ text: String?) -> Void)? = nil) {
        var userIdTextField: UITextField?
       
      
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            if let userInput = userIdTextField!.text {
                actionHandler?(userInput)
//                self.userInputValue = userInput
            }
            
        })
        
        
        
        let dialog = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        
        dialog.addAction(ok)
        dialog.addAction(cancel)
        dialog.addTextField { (textField) -> Void in
            
            userIdTextField = textField
            userIdTextField?.placeholder = "Enter Your Code Here"
        }
        
        view.present(dialog, animated: true)
        
    }
    
}
