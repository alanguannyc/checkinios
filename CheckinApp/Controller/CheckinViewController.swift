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

class CheckinViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, profileDelegation{
    
    func resetSearch() {
        nameSearchField.text = ""
        nameTable.isHidden = true
    }
    
    @IBAction func addMoreButtonPressed(_ sender: Any) {
        
    }
    
    
    var eventID: Int?
    var attendees: JSON?
    var showForm = false
    var showAddmoreButton = false
    var totalAttendees = [Attendees]()
    var attendeeToPass : Attendees?
    
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
                    self.addMoreLabel.center.y = self.view.center.y - 50.0

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
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.present(ProfileCardViewController(), animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileID") {
            if let vc = segue.destination as? ProfileCardViewController, let attendeeIndex = nameTable.indexPathForSelectedRow?.row {
                vc.profileDelegate = self
                vc.profileAttendee = filteredAttendees[attendeeIndex]
                
            }
        }
    }
    
    

    func updateEventList(){
        let apiURL = ENV.Domains.event + String(eventID!)

        DispatchQueue.main.async {
            Alamofire.request(apiURL, method: .get)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        self.attendees = json["attendees"]
                        self.eventNameLabel.text = json["name"].string! + "Self-Checkin"
                        
                        
                    case .failure( _):
                        return;
                    }
            }
        }
        
    }
}





