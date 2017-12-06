//
//  FutureForecast.swift
//  WeatherApp
//
//  Created by vamsi krishna reddy kamjula on 12/5/17.
//  Copyright © 2017 vamsi krishna reddy kamjula. All rights reserved.
//

import Foundation
import RealmSwift

class FutureForecast: Object {
    @objc dynamic var highTemperature: String? = nil
    @objc dynamic var lowTemperature: String? = nil
    @objc dynamic var day: String? = nil
    
    override static func primaryKey() -> String? {
        return "day"
    }
}
