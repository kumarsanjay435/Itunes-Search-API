//
//  APIService2.swift
//  Itunes
//
//  Created by Sanjay on 11/16/17.
//  Copyright © 2017 MP. All rights reserved.
//

import Foundation

enum Results<T> {
   case Success(T)
   case error(String)
}

class APIService2: NSObject {
    var query = "software"
    lazy var endpointt: String = { return  "https://itunes.apple.com/search?term=yelp&country=us&entity=\(self.query)" }()
    
    //func getDataWithmayo 
    
    
    func getDataWith ( completion: @escaping (Results<[String: AnyObject]>) -> Void) {
        guard let url = URL(string: endpointt ) else { return }
        URLSession.shared.dataTask(with: url){ (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data, options:[.mutableContainers]) as? [String: AnyObject] {
                    completion(.Success(jsonData))
                }
            } catch let error {
                print(error)
            }
            }.resume()
    }
}
