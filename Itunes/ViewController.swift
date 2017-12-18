//
//  ViewController.swift
//  Itunes
//
//  Created by Sanjay on 11/15/17.
//  Copyright © 2017 MP. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var iTunesArrayObject = [String]()
    var resultSearchController = UISearchController()
    var searchActive : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.black
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.delegate = self
            controller.searchBar.backgroundColor = UIColor.clear
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
        self.tableView.reloadData()
        self.iOSNativeApiCall(searchText: "software")
        //self.useMoyaAndAlamofire()
    }
    
    func useMoyaAndAlamofire() {
        let provider = MoyaProvider<MyService>()
        provider.request(.search(term: "yelp", country: "US", entity: "software"), completion: { result in
            switch result {
            case let .success(moyaResponse):
                //self.parseViaSwiftyJson(data: moyaResponse.data)
                self.parseViaMoya(data: moyaResponse)
            case .failure(_): break
            }
        })
    }
    
    
    func iOSNativeApiCall(searchText: String) {
        let service = APIService2()
        self.iTunesArrayObject.removeAll()
        self.tableView.reloadData()
        service.query = searchText
        service.getDataWith { (result) in
            switch result {
            case .Success(let json):
                if let jsonArray = json["results"] as? [[String: AnyObject]] {
                    for ItunesObject in jsonArray {
                        if let str = ItunesObject["artistName"] as? String {
                            print("-----------------------------------------------------")
                            print(ItunesObject["artistId"]!)
                            print(ItunesObject["artistName"]!)
                            print("-----------------------------------------------------")
                            self.iTunesArrayObject.append(str)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .error(let error):
                print(error.description)
            }
        }
    }
    
    func parseViaSwiftyJson(data: Data) {
        do {
            let Jsondata =  try JSON(data: data)
            print(Jsondata["results"][0]["artistName"])
            print(Jsondata["results"][0]["artistId"])
            print("-----------------------------------------------------")
        } catch { }
    }
    
    func parseViaMoya(data: Response) {
        do {
            print("-----------------------------------------------------")
            let Jsondata =  try JSON(data.mapJSON())
            print(Jsondata["results"][0]["artistName"])
            print(Jsondata["results"][0]["artistId"])
            print("-----------------------------------------------------")
        } catch { }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.iTunesArrayObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for: indexPath)
        cell.textLabel?.text = self.iTunesArrayObject[indexPath.row]
        cell.detailTextLabel?.text = self.iTunesArrayObject[indexPath.row]
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.iOSNativeApiCall(searchText: searchController.searchBar.text!)
    }
}









