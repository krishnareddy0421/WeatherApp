//
//  Constants.swift
//  WeatherApp
//
//  Created by vamsi krishna reddy kamjula on 12/5/17.
//  Copyright © 2017 vamsi krishna reddy kamjula. All rights reserved.
//

import Foundation
import RealmSwift

let API_KEY = "d873c116f9ebc5b90b95f48753f688a7"

typealias CompletionHandler = (_ Success: Bool) -> ()

let realm = try! Realm()
