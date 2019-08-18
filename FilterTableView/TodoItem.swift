//
//  TodoItem.swift
//  FilterTableView
//
//  Created by MB on 8/18/19.
//  Copyright © 2019 MB. All rights reserved.
//

import RealmSwift

class TodoItem : Object{
    
    @objc dynamic var todoId : Int = 0
    @objc dynamic var todoValue : String = ""
    @objc dynamic  var isDone : Bool = false
    @objc dynamic var createdDate : Date? = Date()
    @objc dynamic var updateDate : Date?
    @objc dynamic var isdeleted : Bool = false
    
    override static func primaryKey() -> String?{
         return "todoId"
    }
}
