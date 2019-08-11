//
//  ViewController.swift
//  FilterTableView
//
//  Created by MB on 8/12/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating {
    
    
    
    var array = ["One","Two","Three","Four","Five","Six","Seven","Eight"]
    var filteredArray = [String]()
    
    
    let resultViewController = UITableViewController()
    
    var searchController : UISearchController!
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchController = UISearchController(searchResultsController: resultViewController)
        searchController.searchResultsUpdater = self
        
        
        resultViewController.tableView.dataSource = self
        resultViewController.tableView.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView{
            return array.count
        }
        else{
            return filteredArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == self.tableView{
            cell.textLabel?.text = array[indexPath.row]
        }
        else{
            cell.textLabel?.text = filteredArray[indexPath.row]
        }
        return cell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredArray = array.filter {$0.contains(searchController.searchBar.text!)}
        resultViewController.tableView.reloadData()
    }
    
}

