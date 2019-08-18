//
//  FormViewController.swift
//  CheckinApp
//
//  Created by Alan on 8/13/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit
import Alamofire
import Lottie

protocol formCleanDelegation {
    func cleanForm()
}

class FormViewController: UIViewController {
    var formCleaner : formCleanDelegation?
    var event_id : Int?
     let animationView = LOTAnimationView(name: "checkmark")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmButton.layer.shadowRadius = 3
        confirmButton.layer.shadowColor = UIColor.gray.cgColor
        confirmButton.layer.shadowOpacity = 1
        
        confirmButton.titleLabel!.numberOfLines = 1;
        confirmButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        animationView.center = self.view.center
        self.view.addSubview(animationView)
        
        
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
        
        var newAttendee : Attendees
        if let firstname = firstName.text, let lastname = lastName.text, let company = company.text, let title = titleName.text, let email = email.text {
            newAttendee = Attendees(id : event_id!, event_id : event_id!, firstName: firstname, lastName: lastname, company: company, title: title, email: email, checkin: true)
            addNewAttendee(newAttendee)
        }
        
        
        
        
        
    }
    
    func addNewAttendee(_ attendee :Attendees){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = Date()
        let checkedinDate = formatter.string(from: date)
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(attendee)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
        let apiURL = ENV.Domains.attendees
        
        let params = [
            "firstName" : attendee.firstName,
            "lastName" : attendee.lastName,
            "email" : attendee.email,
            "title" : attendee.title,
            "company" : attendee.company,
            "checkin" : attendee.checkin!,
            "event_id" : event_id!,
            "checkedin_at" : checkedinDate,
            ] as [String : Any]
        
        Alamofire.request(apiURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response .result {
            case .success( _) :
                self.animationView.play { (true) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.animationView.stop()
                        self.clearAllTextFields()
                        self.dismiss(animated: true, completion: nil)
                        self.formCleaner!.cleanForm()
                    }
                    
                }
                
            case .failure(let error) :
                let error = error as Error
                print(error.localizedDescription)
                
            }
        }
        
    }
    
    func clearAllTextFields(){
        var views = [UITextField]()
        views = getTextfield(view: self.view)
        
        for view in views {
            view.text = ""
        }
    }
    
    func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
    }
}
