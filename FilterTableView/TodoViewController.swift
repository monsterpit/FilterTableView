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
    func removeTodoItem(at index : Int) -> ()
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
        viewModel?.newItem = textField.text
        
        DispatchQueue.global(qos: .background).async {
            self.viewModel?.onAddTodoItem()
        }
        
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
        
        viewModel?.items[indexPath.row].onItemSelected()
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        
        let removeAction = UIContextualAction(style: .normal,
                                              title: "remove",
                                              handler: { (action, view,
                                                success : (Bool) -> ()   //Called when someAction in Completed
                                                ) in
                                                
                                                DispatchQueue.global(qos: .background).async {
                                                    self.viewModel?.onItemRemove(todoItem: (self.viewModel?.items[indexPath.row].id))
                                                }
                                                
                                                success(true)
        })
        removeAction.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
}

//receieve this value back from viewmodel to viewcontroller
extension TodoViewController : TodoView{
    func addTodoItem() {
        
        guard let items = viewModel?.items else{ print("Items are empty"); return }
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(item: items.count - 1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
            
            self.textField.text = self.viewModel?.newItem
        }

    }
    
    func removeTodoItem(at index : Int){
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    
}




