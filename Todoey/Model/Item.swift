//
//  Item.swift
//  Todoey
//
//  Created by Nafea Elkassas on 13/01/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateModified : Date?
    
    // Inverse Relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
