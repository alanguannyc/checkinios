//
//  ViewController.swift
//  CheckinApp
//
//  Created by Alan on 8/8/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, profileDelegation  {
    func resetSearch() {
        updateEventList()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventlist?.count ?? 1
    }
    
    @IBOutlet weak var eventTableView: UITableView!
    var eventlist : JSON?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.dataSource = self
        eventTableView.delegate = self
        
        updateEventList()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateEventList()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventcell") as! EventTableViewCell
        cell.eventName.text = "LPX Seminar"
        
        if let resource = eventlist{
            
            cell.eventName.text = (resource[indexPath.row]["name"]).string
            if let time = resource[indexPath.row]["fromDate"].string {
                cell.eventDate.text = String(time.split(separator: "T")[0] + " " + time.split(separator: "T")[1])
            }
            
            
            cell.checkinStatus.text = String(resource[indexPath.row]["attendees"].filter{ $1["checkin"] == "1" }.count) + " checked in"
          
            
        }
        return cell
        
        
    }
    var alert = PasswordAlert(alertTitle: "Set up your safe code", alertMessage: nil )

    var value : String?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alert.askForPasscode(view: self) { (result) in
            self.value = result
            if(self.value != ""){
                self.performSegue(withIdentifier: "checkin", sender: self)
            } else {
                
            }
            
        }
//        alert.showAlert(view: self) { result in
//            switch result {
//            case .success(let count):
//                print(count)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        showAlert(alertTitle: "Set up your safe code", alertMessage: nil )
        
        
        
        
    }
    
    func showAlert(alertTitle: String, alertMessage: String?){
        var userIdTextField: UITextField?
        
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            if let userInput = userIdTextField!.text {
                self.value = userInput
                
                
            }
        })
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        let dialog = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        
        dialog.addAction(ok)
        dialog.addAction(cancel)
        dialog.addTextField { (textField) -> Void in
            
            userIdTextField = textField
            userIdTextField?.placeholder = "Type in your ID"
        }
        
        self.present(dialog, animated: true, completion: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        
        let destinationVC = segue.destination as! CheckinViewController
        
        if let indexPath = eventTableView.indexPathForSelectedRow {
            destinationVC.eventID = eventlist?[indexPath.row]["id"].int
            destinationVC.passcode = value
//            if let attendees = eventlist?[indexPath.row]["attendees"].array {
//                
//                
//                for attendee in attendees {
//                    let id = attendee["id"].int!
//                    
//                    let eventID = Int(attendee["event_id"].string!)
//                    let firstname = attendee["firstName"].string
//                    let lastname = attendee["lastName"].string
//                    let companyname = attendee["company"].string
//                    let titlename = attendee["title"].string
//                    let emailname = attendee["email"].string
//                    let checkin = attendee["checkin"].boolValue
//                    
//                    destinationVC.totalAttendees.append(Attendees(id: id, event_id: Int(eventID!), firstName: firstname!, lastName: lastname!, company: companyname!, title: titlename!, email: emailname!, checkin: checkin))
//                    
//
//                    
//                }
//
//            }
            
        }
    }
    let apiURL = ENV.Domains.events
    
    func updateEventList(){
        
        DispatchQueue.main.async {
            Alamofire.request(self.apiURL, method: .get)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        self.eventlist = json
                        self.eventTableView.reloadData()
                        
                        
                        
                    case .failure( _):
                        return;
                    }
            }
        }

    }

}

