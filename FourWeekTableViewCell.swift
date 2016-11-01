//
//  FourWeekTableViewCell.swift
//  tractwork
//
//  Created by manatee on 10/8/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit

class FourWeekTableViewCell: UITableViewCell {

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var totalHoursLabel: UILabel!
    @IBOutlet weak var weekNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
