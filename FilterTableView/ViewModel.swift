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


class ItemViewModel : ItemPresentable{
    var id: String?
    
    var textValue: String?
    
    init(id: String,textValue: String ){
        self.id = id
        self.textValue = textValue
        
    }
    
    func selectedItem(){
        print("Selected ID is \(id!)")
    }
}



//MARK:- VC
//Full ViewContrroller View Model i.e. tableView and button tap

protocol ViewModelDelegate{
    func todoitemAdded() -> ()
}


class ViewModel {

    var ViewModelDelegate : ViewModelDelegate?
    
    var newItem : String?
    
    var items : [ItemViewModel] = []
    
    init(){
        
        let item1   = ItemViewModel(id: "1", textValue: "Washroom")
        
        let item2  = ItemViewModel(id: "2", textValue: "bathRoom")
        
        let item3  = ItemViewModel(id: "3", textValue: "HellRoom")
        
        items.append(contentsOf: [item1,item2,item3])
        
    }
    
    func itemAdd() {
        guard let newItem = newItem  else{ return}
        let item   = ItemViewModel(id: "\(items.count + 1)", textValue: newItem)
        items.append(item)
        self.newItem = ""
        ViewModelDelegate?.todoitemAdded()
    }
    


}

