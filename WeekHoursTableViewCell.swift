//
//  WeekHoursTableViewCell.swift
//  tractwork
//
//  Created by manatee on 9/19/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit

class WeekHoursTableViewCell: UITableViewCell {
    @IBOutlet weak var weekHoursLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
