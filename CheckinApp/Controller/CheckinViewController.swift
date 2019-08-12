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
        <#code#>
    }
    
    
    
    var eventID: Int?
    var attendees: JSON?

    
    
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballClipRotatePulse, color: .lightGray)
    
    
    @IBOutlet weak var nameSearchField: UITextField!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    @IBOutlet weak var nameTable: UITableView!
    
    var fileredFootballer = [Footballer]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEventList()
        nameTable.dataSource = self
        nameTable.delegate = self
        nameSearchField.delegate = self
        definesPresentationContext = true
        
        nameSearchField.addTarget(self, action: #selector(CheckinViewController.nameSearchStarted(for :)), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func nameSearchStarted(for searchText: UITextField){
//        fileredFootballer = allPlayers.filter {
//            player in
//            return player.name.lowercased().contains(Character((searchText.text?.lowercased())!))
//        }
        
       
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.activityIndicatorView.stopAnimating()
            if let content = searchText.text {
                self.fileredFootballer = content.isEmpty ? allPlayers : allPlayers.filter { (Footballer) -> Bool in
                    return Footballer.name.range(of: content, options: .caseInsensitive, range: nil, locale: nil) != nil
                }
            }
            self.nameTable.reloadData()
        }
        
        
        
        
       
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileredFootballer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = nameTable.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = fileredFootballer[indexPath.row].name
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.present(ProfileCardViewController(), animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "profileID") {
            if let segue.destination =
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
                        self.eventNameLabel.text = json["name"].string
                        
                        
                    case .failure( _):
                        return;
                    }
            }
        }
        
    }
}





