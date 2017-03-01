//
//  SingleTimePunchTableViewCell.swift
//  tractwork
//
//  Created by manatee on 11/2/16.
//  Copyright © 2016 diligentagility. All rights reserved.
//

import UIKit

class SingleTimePunchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusRing: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var punchTimeLabel: UILabel!
    @IBOutlet weak var editPunchTimeField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let commonTextFieldAttributes: NSDictionary = [NSForegroundColorAttributeName:UIColor.black]
        editPunchTimeField.attributedPlaceholder = NSAttributedString(string: "time", attributes: commonTextFieldAttributes as? [String: AnyObject])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
