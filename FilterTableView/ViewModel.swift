//
//  ViewModel.swift
//  FilterTableView
//
//  Created by MB on 8/13/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation

//MARK:- Cell
//View Model For Cell
protocol ItemPresentable{
    var id : String? {get}
    var textValue : String? {get}
}


protocol TodoItemViewDelegate {
     func onItemSelected() -> ()
}


class ItemViewModel : ItemPresentable {
    var id: String?
    
    var textValue: String?
    
    init(id: String,textValue: String ){
        self.id = id
        self.textValue = textValue
        
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
    
    
}



//MARK:- VC
//Full ViewContrroller View Model i.e. tableView and button tap

protocol TodoViewDelegate{
    func onAddTodoItem() -> ()
    func onItemRemove(todoItem : String?) -> ()
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
        
        let item1   = ItemViewModel(id: "1", textValue: "Washroom")
        
        let item2  = ItemViewModel(id: "2", textValue: "bathRoom")
        
        let item3  = ItemViewModel(id: "3", textValue: "HellRoom")
        
        items.append(contentsOf: [item1,item2,item3])
        
    }
    
    
}

extension TodoViewModel : TodoViewDelegate{
    
    func onAddTodoItem() -> (){
        guard let newItem = newItem ,newItem != "" else{ return}
        let item   = ItemViewModel(id: "\(items.count + 1)", textValue: newItem)
        items.append(item)
        
        self.newItem = ""
        
        //has soon as item is added we are notifing the view that item is added
        self.view?.addTodoItem()
    }
    
    
    func onItemRemove(todoItem: String?) {
        
        guard let todoItem = todoItem, let index = items.firstIndex(where: { $0.id == todoItem
        }) else{ print("item for the index doesnt exist"); return}
        
        items.remove(at: index)
        
        //has soon as item is removed we are notifing the view that item is added
        self.view?.removeTodoItem(at : index)
        
    }
    
}

