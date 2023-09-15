//
//  CategoryCell.swift
//  Todoey
//
//  Created by Nafea Elkassas on 13/07/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
       //MARK: - Outlets
    @IBOutlet weak var cellContent: UIView!
    @IBOutlet weak var tasksCount: UILabel!
    @IBOutlet weak var lableTxt: UILabel!
    
       //MARK: - LifeCycleMethods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellContent.clipsToBounds = true
        self.cellContent.layer.cornerRadius = 10
        self.cellContent.layer.borderWidth = 2
        self.cellContent.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
