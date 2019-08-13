//
//  FormViewController.swift
//  CheckinApp
//
//  Created by Alan on 8/13/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.shadowRadius = 3
        confirmButton.layer.shadowColor = UIColor.gray.cgColor
        confirmButton.layer.shadowOpacity = 1
        
        confirmButton.titleLabel!.numberOfLines = 1;
        confirmButton.titleLabel!.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var company: UITextField!
    
    @IBOutlet weak var titleName: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
    }
}
