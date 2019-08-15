//
//  TodoViewController.swift
//  FilterTableView
//
//  Created by MB on 8/12/19.
//  Copyright © 2019 MB. All rights reserved.
//https://www.youtube.com/watch?v=6KC1GdLnez0
//rxcocoa tableview
//https://www.youtube.com/watch?v=4RyhnwIRjpA

import UIKit


//receieve this value back from viewmodel to viewcontroller
protocol TodoView : class{
    func addTodoItem()->()
}

class TodoViewController: UIViewController{
    
    // var array = ["One","Two","Three","Four","Five","Six","Seven","Eight"]
    var array = [String]()
    var filteredArray = [String]()
    
    var viewModel : TodoViewModel?
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  viewModel.ViewModelDelegate = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        //passing ViewControllere
        viewModel = TodoViewModel(view : self)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        viewModel?.onAddTodoItem(newValue : textField.text )
    }
    
}


extension TodoViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (viewModel?.items.count)!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        cell.configure(withItemViewModel: (viewModel?.items[indexPath.row])!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel?.items[indexPath.row].selectedItem()
        
    }
}

//receieve this value back from viewmodel to viewcontroller
extension TodoViewController : TodoView{
    func addTodoItem() {
        
        guard let items = viewModel?.items else{ print("Items are empty"); return }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(item: items.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        
        textField.text = ""
    }
    
    
}




