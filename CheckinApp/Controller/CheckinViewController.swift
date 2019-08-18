//
//  CheckinViewController.swift
//  CheckinApp
//
//  Created by Alan on 8/8/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class CheckinViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, profileDelegation, formCleanDelegation{
    
    func resetSearch() {
        nameSearchField.text = ""
        nameTable.isHidden = true
        addMoreLabel.isHidden = true
        updateEventList()
        
        nameTable.reloadData()
    }
    
    func cleanForm() {
        resetSearch()
    }
    
    @IBAction func addMoreButtonPressed(_ sender: Any) {
//        self.present(FormViewController(),animated: true)
    }
    
    
    var eventID: Int?
    var attendees: JSON?
    var showForm = false
    var showAddmoreButton = false
    var totalAttendees = [Attendees]()
    var attendeeToPass : Attendees?
    var passcode : String?
    
    @IBOutlet weak var addMoreLabel: UIStackView!
    @IBOutlet weak var addMoreButton: UIButton!
    
    @IBOutlet weak var addMoreButtonHeight: NSLayoutConstraint!
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballClipRotatePulse, color: .lightGray)
    
    
    @IBOutlet weak var nameSearchField: UITextField!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var nameTable: UITableView!
    
    @IBOutlet weak var cellView: UIView!
    var filteredAttendees = [Attendees]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEventList()
        nameTable.dataSource = self
        nameTable.delegate = self
        nameSearchField.delegate = self
        definesPresentationContext = true
        nameTable.isHidden = true
        addMoreLabel.isHidden = true
        addMoreLabel.alpha = 0
        nameTable.rowHeight = UITableViewAutomaticDimension
        nameTable.estimatedRowHeight = 600
        nameSearchField.addTarget(self, action: #selector(CheckinViewController.nameSearchStarted(for :)), for: UIControl.Event.editingChanged)
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        nameSearchField.leftView = paddingView
        nameSearchField.leftViewMode = .always
        
        
        
    }
    
    @objc func nameSearchStarted(for searchText: UITextField){

        
       
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.activityIndicatorView.stopAnimating()
            if let content = searchText.text {
                self.filteredAttendees = content.isEmpty == true ? self.totalAttendees : self.totalAttendees.filter { (Attendee) -> Bool in
                    return Attendee.firstName.range(of: content, options: .caseInsensitive, range: nil, locale: nil) != nil ||
                    Attendee.lastName.range(of: content, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
            }
            if (self.filteredAttendees.isEmpty) {
                self.addMoreLabel.isHidden = false
                self.nameTable.isHidden = true
                UIView.animate(withDuration: 1.0, animations: {
//                    self.addMoreLabel.center.y = self.view.center.y - 50.0
                        self.addMoreLabel.alpha = 1
                })
            } else {
                self.addMoreLabel.isHidden = true
                self.nameTable.isHidden = false
            }
            self.nameTable.reloadData()
        }
        
        
        
        
       
    }
    

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAttendees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = nameTable.dequeueReusableCell(withIdentifier: "cell") as! NameTableViewCell
        cell.nametableName.text = filteredAttendees[indexPath.row].firstName + " " + filteredAttendees[indexPath.row].lastName
        cell.nametableTitle.text = filteredAttendees[indexPath.row].title + " at " +  filteredAttendees[indexPath.row].company
        cell.nametableCheckin.text = filteredAttendees[indexPath.row].checkin == true ? "Already Checkedin" : ""
        cell.checkmarkImage.isHidden = filteredAttendees[indexPath.row].checkin == true ? false : true
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        self.present(ProfileCardViewController(), animated: true, completion: nil)
    }
    
    @IBAction func ExitButtonPressed(_ sender: Any) {
        authenticatePasscode()
        
    }
    
    func authenticatePasscode(){
        let alert = PasswordAlert(alertTitle: "Enter your safe code", alertMessage: nil )
        let warning = PasswordAlert(alertTitle: "Your passcode doesn't match.", alertMessage: "Try again?")
        
        alert.askForPasscode(view: self, cancelHandler: nil) { (result) in
            if (result == self.passcode) {
                self.dismiss(animated: true, completion: nil)
            } else {
                
                warning.showWarning(view: self){ (yes : Bool) in
                    if (yes) {
                        self.authenticatePasscode()
                    }
                    
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileID") {
            if let vc = segue.destination as? ProfileCardViewController, let attendeeIndex = nameTable.indexPathForSelectedRow?.row {
                vc.profileDelegate = self
                vc.profileAttendee = filteredAttendees[attendeeIndex]
                
                
            }
        } else if (segue.identifier == "addMoreForm") {
            if let destinationNavigationController = segue.destination as? UINavigationController {
                let targetController = destinationNavigationController.topViewController as! FormViewController
                targetController.event_id = eventID
                targetController.formCleaner = self
            }
        }
    }
    
    

    func updateEventList(){
        let apiURL = ENV.Domains.event + String(eventID!)
        totalAttendees = [Attendees]()
        DispatchQueue.main.async {
            Alamofire.request(apiURL, method: .get)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        self.attendees = json["attendees"]
                        self.eventNameLabel.text = json["name"].string! + " check-in"
                        if let attendees = self.attendees!.array {
                            
                            
                            for attendee in attendees {
                                let id = attendee["id"].int!
                                
                                let eventID = Int(attendee["event_id"].string!)
                                let firstname = attendee["firstName"].string
                                let lastname = attendee["lastName"].string
                                let companyname = attendee["company"].string
                                let titlename = attendee["title"].string
                                let emailname = attendee["email"].string
                                let checkin = attendee["checkin"].boolValue
                                
                                self.totalAttendees.append(Attendees(id: id, event_id: Int(eventID!), firstName: firstname!, lastName: lastname!, company: companyname!, title: titlename!, email: emailname!, checkin: checkin))
                                
                                
                                
                            }
                            
                        }
                        
                    case .failure( _):
                        return;
                    }
            }
        }
        
    }
}





