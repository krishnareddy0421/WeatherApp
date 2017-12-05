//
//  UserLocation.swift
//  WeatherApp
//
//  Created by vamsi krishna reddy kamjula on 12/5/17.
//  Copyright © 2017 vamsi krishna reddy kamjula. All rights reserved.
//

import Foundation
import CoreLocation

class UserLocation {
    
    static let instance = UserLocation()
    
    func gotUserLocation(locality: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "https://api.darksky.net/forecast/\(API_KEY)/\(latitude),\(longitude)"
        let url = URL(string: urlString)
        
    }
}
