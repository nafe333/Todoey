//
//  ItemsCell.swift
//  Todoey
//
//  Created by Nafea Elkassas on 13/07/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit

class ItemsCell: UITableViewCell {
    
    @IBOutlet weak var cellContent: UIView!
    @IBOutlet weak var labelTxt: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
