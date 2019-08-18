//
//  ViewModel.swift
//  FilterTableView
//
//  Created by MB on 8/13/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON


//MARK:- For Menu in Cell Items
//Menu for Items (rows) of tableView
protocol TodoMenuItemViewPresentable {
    var title : String? {get set}
    var backgroundColor : String? {get}   //String it's better to avoid UIKit foundation elements
    
}

protocol TodoMenuItemViewDelegate {
    func onMenuItemSelected() -> ()

}

class TodoMenuItemViewModel : TodoMenuItemViewPresentable,TodoMenuItemViewDelegate {

    var title: String?
    
    var backgroundColor: String?
    
    weak var parent : TodoItemViewDelegate?
    
    init(parentViewModel : TodoItemViewDelegate){
        self.parent = parentViewModel
    }
    
    func onMenuItemSelected() {
        //Base class does not require an implementation
    }

}

class RemoveMenuItemViewModel : TodoMenuItemViewModel{
    
    override func onMenuItemSelected() {
        print("Remove Item Selected")
        parent?.onRemoveMenuItemSelected()
    }
    
}


class DoneMenuItemViewModel : TodoMenuItemViewModel{
    
    override func onMenuItemSelected() {
        print("Done Item Selected")
        parent?.onDoneMenuItemSelected()
    }
    
}




//MARK:- Cell
//View Model For Cell
protocol ItemPresentable{
    var id : String? {get}
    var textValue : String? {get}
    var menuItems : [TodoMenuItemViewPresentable]? {get}
    var isDone : Bool? {get set}
}


protocol TodoItemViewDelegate : class{
    func onItemSelected() -> ()
    func onDoneMenuItemSelected() -> ()
    func onRemoveMenuItemSelected() -> ()
}


class ItemViewModel : ItemPresentable {
    
    var isDone : Bool? = false
    
    var menuItems: [TodoMenuItemViewPresentable]? = []
    
    var id: String?
    
    var textValue: String?
    
    weak var parent: TodoViewDelegate?
    
    init(id: String,textValue: String,parentViewModel : TodoViewDelegate ){
        self.id = id
        self.textValue = textValue
        self.parent = parentViewModel
        
        let removeMenuItem = RemoveMenuItemViewModel(parentViewModel: self)
        removeMenuItem.title = "Remove"
        removeMenuItem.backgroundColor = "EC3C1A" //light red 
        
        let doneMenuItem = DoneMenuItemViewModel(parentViewModel: self)
        doneMenuItem.title = isDone! ? "UnDone" : "Done"
        doneMenuItem.backgroundColor = "77C344" //light Green
        
        
        menuItems?.append(removeMenuItem)
        menuItems?.append(doneMenuItem)
        
        
    }

}


extension ItemViewModel : TodoItemViewDelegate{
    
    /*!
     * @discussion on item recieved in view model on didSelectRowAt
     * @params Void
     * @return Void
     */
    func onItemSelected() {
         print("Selected ID is \(id!)")
    }
    
    func onDoneMenuItemSelected() {
        parent?.onTodoItemDone(todoItemId: id!)
    }
    
    func onRemoveMenuItemSelected() {
        parent?.onItemRemove(todoItemId: id!)
    }
    
}



//MARK:- VC
//Full ViewContrroller View Model i.e. tableView and button tap

protocol TodoViewDelegate : class{
    func onAddTodoItem() -> ()
    func onItemRemove(todoItemId : String?) -> ()
    func onTodoItemDone(todoItemId : String?) -> ()
}

//for data binding
protocol TodoViewModelPresentable{
    var newItem : String? {get}
}


import RealmSwift

class TodoViewModel : TodoViewModelPresentable  {
    
    
    var newItem : String?
    

 
    //var items : [ItemPresentable]= []
    var items : Variable<[ItemPresentable]> = Variable([])
    
    
    var database : Database?
    
    var notificationToken : NotificationToken? = nil
    

    init(){
        
        APIService.sharedInstance.fetchAllTodo { (data) in

            
            //Using SwiftyJSON
            let data = JSON(data)
            
            if let todoArray = data.array {//.array for optional ,.arrayValue for explicitly unwrapped array, .arrayObject for [Any]?
                
                todoArray.forEach({ (todoItemDict) in
                    
                    if let itemDict = todoItemDict.dictionary{
                        
                        if let id = itemDict["id"]?.int, let value = itemDict["value"]?.string{
                            
                            print("id is \(id) and value is \(value)")
                            
                            self.database?.createOrUpdate(todoItemValue: value)
                            
                        }
                        
                    }
                    
                })
                
            }
            
            
            
        }
        
        database = Database.singleton
        
        let todoItemResults = database?.fetch()
        
        notificationToken = todoItemResults?._observe({ [weak self] (changes : RealmCollectionChange) in
            
            switch(changes){
            case .initial:  //listening to all the existing records
                
                todoItemResults?.forEach({ (todoItemEntity) in
                    
                    let itemIndex = todoItemEntity.todoId
                    let itemValue = todoItemEntity.todoValue
                    
                    
                    let item   = ItemViewModel(id: "\(itemIndex)", textValue: itemValue, parentViewModel: self!)
                    item.isDone = todoItemEntity.isDone
                    self?.items.value.append(item)
                    
                    
                })
                
                break
            case .update(_,let deletions,let insertions,let modifications ):  //listening to all the updates like delete,insert,update  [Int] returns array of indexs
                
                insertions.forEach({ (index) in
                    
                    let todoItemEntity = todoItemResults![index]
                    
                    let itemIndex = todoItemEntity.todoId
                    let itemValue = todoItemEntity.todoValue
                    
                    
                    let item   = ItemViewModel(id: "\(itemIndex)", textValue: itemValue, parentViewModel: self!)
                    self?.items.value.append(item)
                    
                })
                
                modifications.forEach({ (index) in
                    
                    let todoItemEntity = todoItemResults![index]
                    
                    guard  let index = self?.items.value.firstIndex(where: { Int($0.id!) == todoItemEntity.todoId
                    }) else{ print("item for the index doesnt exist"); return}
                    
                    //For Deletion
                    if todoItemEntity.isdeleted == true{
                        
                        self?.items.value.remove(at: index)
                        
                        self?.database?.delete(primaryKey: todoItemEntity.todoId)
                        
                    }
                        //For Modifications / Updates
                    else{
                        
                        var todoItem = self?.items.value[index]
                        
                        todoItem?.isDone!.toggle()
                        
                        if var doneMenuItem = todoItem?.menuItems?.filter({ (todoMenuItem) -> Bool in
                            todoMenuItem is DoneMenuItemViewModel
                        }).first{
                            doneMenuItem.title = todoItemEntity.isDone ? "UnDone" : "Done"
                        }
                    }
                })

                break
            case .error(let error):
                break
                
            }
            
            //MARK:- Sort Must See
            self?.items.value.sort{
                
                // 2,1    3,2 3,1    4,1 4,2 4,3
                
                if(!($0.isDone!) && !($1.isDone!)){
                    return $0.id! < $1.id!
                }
                else if(($0.isDone!) && ($1.isDone!)){
                    return $0.id! < $1.id!
                }
                
                return !($0.isDone!) && $1.isDone!
                
            }
            
            
        })
        
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    
}

extension TodoViewModel : TodoViewDelegate{
    
    func onAddTodoItem() -> (){
        guard let newItem = newItem ,newItem != "" else{ return}

        database?.createOrUpdate(todoItemValue: newItem)
        
        self.newItem = ""
        
    }
    
    
    func onItemRemove(todoItemId: String?) {
        
        database?.softDelete(primaryKey: Int(todoItemId!)!)
        
        print("Todo Item delete with id \(todoItemId)")
        
    }
    
    func onTodoItemDone(todoItemId: String?) {
        
        database?.isDone(primaryKey: Int(todoItemId!)!)

        print("Todo Item done with id \(todoItemId)")
        

    }
    
}

