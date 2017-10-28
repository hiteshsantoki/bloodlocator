//
//  TableController.swift
//  BloodLocator
//
//  Created by Cronabit 1 on 09/10/17.
//  Copyright © 2017 Cronabit 1. All rights reserved.
//

import UIKit

class TableController: UITableViewController {
    
    var Searchdata: String?
    var TableData:Array< String > = Array < String >()
    var TableId:Array< String > = Array < String >()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        get_data_from_url("https://api.data.gov.in/resource/e16c75b6-7ee6-4ade-8e1f-2cd3043ff4c9?format=json&limit=1000&api-key=579b464db66ec23bdd000001f6ecc0b607a44411688dea4d5a45525c")
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = TableData[indexPath.row]
        
        return cell
    }
    
    
    
    
    
    
    func get_data_from_url(_ link:String)
    {
        let url:URL = URL(string: link)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                return
            }
            
            self.extract_json(data!)
            
        })
        
        task.resume()
        
    }
    
    func extract_json(_ data: Data)
    {
        
        do
        {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            let blogs = json?["records"] as? [[String: Any]]
            for blog in blogs! {
                let id = blog["id"] as? String
                let name = blog["h_name"] as? String
                let city = blog["city"] as? String
                let state = blog["state"] as? String
                let address = blog["address"] as? String
                let pincode = blog["pincode"] as? String
                
                
                if name?.lowercased().range(of:Searchdata!.lowercased()) != nil || address?.lowercased().range(of:Searchdata!.lowercased()) != nil || state?.lowercased().range(of:Searchdata!.lowercased()) != nil || city?.lowercased().range(of:Searchdata!.lowercased()) != nil || pincode?.lowercased().range(of:Searchdata!.lowercased()) != nil{
                    
                    TableData.append(name!)
                    TableId.append(id!)
                    
                }

            }
            
        }
        catch
        {
            print("Error deserializing JSON: \(error)")
        }
        
        DispatchQueue.main.async(execute: {self.do_table_refresh()})
        
    }
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "passdata2"{
            let TC2 = segue.destination as? detailController
            let blogIndex = tableView.indexPathForSelectedRow?.row
            do {
                TC2?.datadetail = TableId[blogIndex!]
            }
}
}
}
