//
//  APIService.swift
//  FilterTableView
//
//  Created by MB on 8/18/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

protocol APIServiceProtocol{
    
    associatedtype ResponseData
    
   // func fetchAllTodo(completion : @escaping (ResponseData)-> ()) -> ()
    func fetchAllTodo() -> (ResponseData)
}


class APIService : APIServiceProtocol{

    static let sharedInstance : APIService = APIService()
    
    private init(){}
    
    typealias ResponseData = Observable<JSON>
    
    func fetchAllTodo() ->  Observable<JSON>{
        
        let url = URL(string: "http://demo9457057.mockable.io/")!
        

       return Observable.create { (observer) -> Disposable in
            
        let request = Alamofire.request(url).responseJSON { (response) in
            
            //            print(response.request)
            //            print(response.response?.statusCode)
            //
            //            completion(response.data!)
            
            
            
            switch response.result{
                
            case .success(let value):
                if let statusCode = response.response?.statusCode, statusCode == 200{
                    
                    let responseJSON = JSON(value)
                    
                    observer.onNext(responseJSON)
                    
                    observer.onCompleted()
                    
                }
                else{
                    print("This is not expected Response")
                    
                    observer.onError(NSError(domain: "Mockable", code: -1, userInfo: nil))
                }
                
                
            case .failure(let error):
                print(error)
                observer.onError(error)
                
            }
            
        }
        
            return Disposables.create {
                //if there is a problem with API we can call request and cancel the request
                request.cancel()
            }
            
        }
        

    
    }
    
    
}
