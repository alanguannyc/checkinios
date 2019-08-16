//
//  NameTableViewCell.swift
//  CheckinApp
//
//  Created by Alan on 8/13/19.
//  Copyright © 2019 Shangguan. All rights reserved.
//

import UIKit

class NameTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.borderWidth = 1.0
        cellView.layer.borderColor = UIColor.black.cgColor
    }

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nametableName: UILabel!
    @IBOutlet weak var nametableCheckin: UILabel!
    
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var nametableTitle: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
