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
import RxSwift
import RxCocoa



class TodoViewController: UIViewController{
    
    // var array = ["One","Two","Three","Four","Five","Six","Seven","Eight"]
    var array = [String]()
    var filteredArray = [String]()
    
    var viewModel : TodoViewModel?
    
    let identifier = "TableViewCell"
    
    let disposeBag = DisposeBag()
    
    
    lazy var searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.barStyle = .default
        controller.searchBar.tintColor = UIColor.black
        controller.searchBar.backgroundColor = UIColor.clear
        controller.searchBar.placeholder = "Search todos..."
        return controller
    }()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  viewModel.ViewModelDelegate = self
        
        tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        
        //passing ViewControllere
        viewModel = TodoViewModel()
        

        viewModel?.filteredItems.asObservable().bind(to: tableView.rx.items(cellIdentifier: identifier, cellType: TableViewCell.self)){index,item,cell in
            cell.configure(withItemViewModel: item)
            }.disposed(by: disposeBag)
        
        let searchBar = searchController.searchBar
        tableView.tableHeaderView = searchBar

        searchBar.rx.text
        .orEmpty
        .distinctUntilChanged()
        .debug()   //To listen to changes
        .bind(to: (viewModel?.searchValue)!)
        .disposed(by: disposeBag)
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        viewModel?.newItem = textField.text
        
        DispatchQueue.global(qos: .background).async {
            self.viewModel?.onAddTodoItem()
        }
        
    }
    
}


extension TodoViewController : UITableViewDelegate {
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        (viewModel?.items.value[indexPath.row] as? TodoItemViewDelegate)?.onItemSelected()
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let itemViewModel = viewModel?.items.value[indexPath.row]
        
        var menuActions : [UIContextualAction] = []
        
        _ = itemViewModel?.menuItems?.map{ menuItem in
      
            let menuAction = UIContextualAction(style: .normal,
                                                  title: menuItem.title,
                                                  handler: { (action, view,
                                                    success : (Bool) -> ()   //Called when someAction in Completed
                                                    ) in
                                                    
                                                    
                                                    if let delegate = menuItem as? TodoMenuItemViewDelegate{
                                                        
                                                        DispatchQueue.global(qos: .background).async {
                                                            
                                                            delegate.onMenuItemSelected()
                                                            
                                                        }
                                                        
                                                    }
 
                                                    success(true)
            })
            
            
            menuAction.backgroundColor = menuItem.backgroundColor?.hexColor
            
            menuActions.append(menuAction)
        }
        
        
        return UISwipeActionsConfiguration(actions: menuActions)
    }
    
}






