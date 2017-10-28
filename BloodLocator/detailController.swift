//
//  detailController.swift
//  BloodLocator
//
//  Created by Cronabit 1 on 10/10/17.
//  Copyright © 2017 Cronabit 1. All rights reserved.
//

import UIKit
import MapKit

class detailController: UIViewController {

    @IBOutlet var detail_id: UILabel!
    @IBOutlet var detail_name: UILabel!
    @IBOutlet var detail_city: UILabel!
    @IBOutlet var detail_state: UILabel!
     @IBOutlet var detail_address: UILabel!
     @IBOutlet var detail_pincode: UILabel!
    @IBOutlet var detail_email: UILabel!
    @IBOutlet var detail_contact: UILabel!
    @IBOutlet var detail_helpline: UILabel!
    @IBOutlet var detail_website: UILabel!
  
    @IBOutlet var mapview: MKMapView!
    
    var datadetail: String?
    var TableData:Array< String > = Array < String >()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        get_data_from_url("https://api.data.gov.in/resource/e16c75b6-7ee6-4ade-8e1f-2cd3043ff4c9?format=json&limit=1000&api-key=579b464db66ec23bdd000001f6ecc0b607a44411688dea4d5a45525c&filters[id]="+datadetail!)
        
        
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
                let name = blog["h_name"] as? String
                let city = blog["city"] as? String
                let state = blog["state"] as? String
                let address = blog["address"] as? String
                let pincode = blog["pincode"] as? String
                let contact = blog["contact"] as? String
                let helpline = blog["helpline"] as? String
                let website = blog["website"] as? String
                let email = blog["email"] as? String
                let latitude = blog["latitude"] as? String
                let longitude = blog["longitude_"] as? String
                
                detail_id.text = datadetail
                detail_name.text = name
                detail_city.text = city
                detail_state.text = state
                detail_address.text = address
                detail_pincode.text = pincode
                detail_contact.text = contact
                detail_helpline.text = helpline
                detail_website.text = website
                detail_email.text = email

                if (latitude != "NA") && (longitude != "NA")
                {
                let span:MKCoordinateSpan = MKCoordinateSpanMake(2.0,2.0)
                let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake((latitude! as NSString).doubleValue,(longitude! as NSString).doubleValue)
                let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
                
                mapview.setRegion(region, animated: true)
                
                let annotaion = MKPointAnnotation()
                
                annotaion.coordinate = location
                annotaion.title = "Current Location"
                
                mapview.addAnnotation(annotaion)
                }
                else
                {
                    mapview.isHidden = true
                }
            }
            
        }
        catch
        {
            print("Error deserializing JSON: \(error)")
        }
        
    }
    
   }
