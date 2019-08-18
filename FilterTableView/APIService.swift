//
//  APIService.swift
//  FilterTableView
//
//  Created by MB on 8/18/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation
import Alamofire

protocol APIServiceProtocol{
    
    associatedtype ResponseData
    
    func fetchAllTodo(completion : @escaping (ResponseData)-> ()) -> ()
    
}


class APIService : APIServiceProtocol{

    static let sharedInstance : APIService = APIService()
    
    private init(){}
    
    typealias ResponseData = Data
    
    func fetchAllTodo(completion: @escaping (Data) -> ()) {
        
        let url = URL(string: "http://demo9457057.mockable.io/")!
        
        Alamofire.request(url).responseJSON { (response) in
            
            print(response.request)
            print(response.response?.statusCode)
            
            completion(response.data!)
            
        }
        
    }
    
    
}
