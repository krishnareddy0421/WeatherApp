//
//  UserLocation.swift
//  WeatherApp
//
//  Created by vamsi krishna reddy kamjula on 12/5/17.
//  Copyright © 2017 vamsi krishna reddy kamjula. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON
import RealmSwift

class UserLocation {
    
    static let instance = UserLocation()
    var locationSummary: String?
    var locationTemperature: Int?
    
    func gotUserLocation(locality: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping CompletionHandler) {
        let urlString = "https://api.darksky.net/forecast/\(API_KEY)/\(latitude),\(longitude)"
        let url = URL(string: urlString)
        
        Alamofire.request(url!).responseData { (response) in
            if response.error != nil {
                completion(false)
                return
            }
            guard let json = JSON(response.result.value!).dictionary else {
                completion(false)
                return
            }
            guard let current = json["currently"]?.dictionaryValue else {
                completion(false)
                return
            }
            guard let summary = current["summary"]?.string else {
                completion(false)
                return
            }
            guard let temperature = current["temperature"]?.double else {
                completion(false)
                return
            }
            self.locationSummary = summary
            self.locationTemperature = Int(temperature)
            completion(true)
        }
        
    }
}
