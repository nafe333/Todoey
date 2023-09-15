//
//  Category.swift
//  Todoey
//
//  Created by Nafea Elkassas on 13/01/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var cellColour : String = ""
    @objc dynamic var donee : Bool = false

    
    // Forward Relationship
    let items = List<Item>()
}
