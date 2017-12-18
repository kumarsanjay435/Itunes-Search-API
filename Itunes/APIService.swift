//
//  APIService.swift
//  Itunes
//
//  Created by Sanjay on 11/15/17.
//  Copyright © 2017 MP. All rights reserved.
//

import Foundation


enum Result <T>{
    case Success(T)
    case Error(String)
}

class APIService: NSObject {
    let query = "dogs"
    //lazy var endPoint: String = { return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=\(self.query)&nojsoncallback=1#" }()
    lazy var endPoint: String = { return "https://itunes.apple.com/search?term=yelp&country=us&entity=software" }()
    
    func getDataWith ( completion: @escaping (Result<[String: AnyObject]>) -> Void) {
        guard let url = URL.init(string: endPoint) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers ]) as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        completion(.Success(json))
                    }
                }
            }  catch let error{
                print(error)
            }
            }.resume()
    }
}
