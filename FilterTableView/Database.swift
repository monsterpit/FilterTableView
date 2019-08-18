//
//  Database.swift
//  FilterTableView
//
//  Created by MB on 8/18/19.
//  Copyright © 2019 MB. All rights reserved.
//

import RealmSwift

class Database{
    
    static let singleton = Database()
    
    private init(){}
    

    func createOrUpdate(todoItemValue : String)-> Void{
        
        let realm = try! Realm()
        
        var todoId : Int? = 1
        
        //Checking for duplicate values if any value isEmpty would be false
        let isEmpty = realm.objects(TodoItem.self).filter{$0.todoValue.lowercased() == todoItemValue.lowercased()}.isEmpty
        
        if !isEmpty{return}
        
        
        //accessing last element in realm Object
        if let lastEntity = realm.objects(TodoItem.self).last{
            todoId = lastEntity.todoId + 1
        }
        
        let todoItemEntity = TodoItem()
        todoItemEntity.todoId = todoId!
        todoItemEntity.todoValue = todoItemValue
        
        //letting isBool be default and created date also default
        //we are not updating so wont change updateDate
        
        try! realm.write {
            //inserted if no value else update
            realm.add(todoItemEntity, update: true)
        }
        
    }
    
    func fetch() -> (Results<TodoItem>){
        let realm = try! Realm()
        
        //Returns all elements of type TodoItem stored in realm
        let todoItemResults = realm.objects(TodoItem.self)
        
        return todoItemResults
    }
    
    
    //realm deletes the row and then send Id of deleted Row so we dont have track of that row we just have its ID
    //to counter it we will have soft delete(tracking with variable then executing hard delete) and hard delete
    //Hard delete
    func delete(primaryKey : Int) -> (Void){
        
         let realm = try! Realm()
        
        
        if let todoItemEntity = realm.object(ofType: TodoItem.self, forPrimaryKey: primaryKey){
          
            try! realm.write {
                realm.delete(todoItemEntity)
            }
            
        }
        
    }
    
    //Soft Delete
    func softDelete(primaryKey : Int) -> (Void){
        
        let realm = try! Realm()
        
        
        if let todoItemEntity = realm.object(ofType: TodoItem.self, forPrimaryKey: primaryKey){
            
            try! realm.write {
                todoItemEntity.isdeleted.toggle()
            }
            
        }
        
    }
    
    
    func isDone(primaryKey : Int) -> Void{
        
        let realm = try! Realm()
        
        
        if let todoItemEntity = realm.object(ofType: TodoItem.self, forPrimaryKey: primaryKey){
            
            try! realm.write {
                todoItemEntity.isDone.toggle()
            }
            
        }
        
    }
}
