//
//  ViewModel.swift
//  FilterTableView
//
//  Created by MB on 8/13/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation




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



class TodoViewModel : TodoViewModelPresentable  {
    
    
    var newItem : String?
    
    //View's delegate weak reference
    weak var view : TodoView?
 
    var items : [ItemViewModel] = []
    
    //only having viewmodel if view is present
    init(view: TodoView){
        
        self.view = view
        
        let item1   = ItemViewModel(id: "1", textValue: "Washroom" , parentViewModel: self)
        
        let item2  = ItemViewModel(id: "2", textValue: "bathRoom" , parentViewModel:  self)
        
        let item3  = ItemViewModel(id: "3", textValue: "HellRoom" , parentViewModel: self)
        
        items.append(contentsOf: [item1,item2,item3])
        
    }
    
    
}

extension TodoViewModel : TodoViewDelegate{
    
    func onAddTodoItem() -> (){
        guard let newItem = newItem ,newItem != "" else{ return}
        let item   = ItemViewModel(id: "\(items.count + 1)", textValue: newItem, parentViewModel: self)
        items.append(item)
        
        self.newItem = ""
        
        //has soon as item is added we are notifing the view that item is added
        self.view?.addTodoItem()
    }
    
    
    func onItemRemove(todoItemId: String?) {
        
        guard let todoItemId = todoItemId, let index = items.firstIndex(where: { $0.id == todoItemId
        }) else{ print("item for the index doesnt exist"); return}
        
        items.remove(at: index)
        
        //has soon as item is removed we are notifing the view that item is added
        self.view?.removeTodoItem(at : index)
        
    }
    
    func onTodoItemDone(todoItemId: String?) {
        
        guard let todoItemId = todoItemId, let index = items.firstIndex(where: { $0.id == todoItemId
        }) else{ print("item for the index doesnt exist"); return}
        
        let todoItem = items[index]
        
        todoItem.isDone!.toggle()
        
        if var doneMenuItem = todoItem.menuItems?.filter({ (todoMenuItem) -> Bool in
            todoMenuItem is DoneMenuItemViewModel
        }).first{
            doneMenuItem.title = todoItem.isDone! ? "UnDone" : "Done"
        }
        
        //MARK:- Sort Must See
        self.items.sort{
            
             // 2,1    3,2 3,1    4,1 4,2 4,3
            
            if(!($0.isDone!) && !($1.isDone!)){
                return $0.id! < $1.id!
            }
            else if(($0.isDone!) && ($1.isDone!)){
                return $0.id! < $1.id!
            }

            return !($0.isDone!) && $1.isDone!
            
        }
        
        
        print("Todo Item done with id \(index)")
        
        self.view?.reloadToDoItems()
    }
    
}

