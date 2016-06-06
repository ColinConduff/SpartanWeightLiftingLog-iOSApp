//
//  SetTableViewCell.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class SetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var setNumberLabel: UILabel!
    @IBOutlet weak var repetitionsLabel: UILabel?
    @IBOutlet weak var weightLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
