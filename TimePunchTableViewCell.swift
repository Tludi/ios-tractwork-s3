//
//  TimePunchTableViewCell.swift
//  tractwork
//
//  Created by manatee on 9/19/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit

class TimePunchTableViewCell: UITableViewCell {
    @IBOutlet weak var punchPairTime: UILabel!
    @IBOutlet weak var outLabel: UILabel!
    @IBOutlet weak var inLabel: UILabel!
    @IBOutlet weak var outRing: UIImageView!
    @IBOutlet weak var inRing: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
