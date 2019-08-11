//
//  ViewController.swift
//  FilterTableView
//
//  Created by MB on 8/12/19.
//  Copyright © 2019 MB. All rights reserved.
//
//https://www.youtube.com/watch?v=4RyhnwIRjpA
import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    var array = ["One","Two","Three","Four","Five","Six","Seven","Eight"]
    var filteredArray = [String]()

    
    var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        tableView?.tableHeaderView = searchBar
        filteredArray = array
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return filteredArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

            cell.textLabel?.text = filteredArray[indexPath.row]

        return cell
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard  !searchText.isEmpty else { filteredArray = array;  tableView.reloadData();       return}
        filteredArray = array.filter {$0.lowercased().contains(searchText.lowercased())}
        tableView.reloadData()
    }

}

