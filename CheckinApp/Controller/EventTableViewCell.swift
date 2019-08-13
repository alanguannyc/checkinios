//
//  EventTableViewCell.swift
//  CheckinApp
//
//  Created by Alan on 8/8/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.borderWidth = 0.5
        cellBackgroundView.layer.cornerRadius = 4
        cellBackgroundView.layer.shadowRadius = 1
        cellBackgroundView.layer.shadowOpacity = 1
    }
    @IBOutlet weak var cellBackgroundView: UIView!
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var checkinStatus: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
