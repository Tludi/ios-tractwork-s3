//
//  TimePunchTableViewCell.swift
//  tractwork
//
//  Created by manatee on 9/19/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit

class TimePunchTableViewCell: UITableViewCell {
    @IBOutlet weak var timePunchLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusColorImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
