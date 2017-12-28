//
//  EventCell.swift
//  Promotional App
//
//  Created by Heady on 27/12/17.
//  Copyright © 2017 Heady. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
