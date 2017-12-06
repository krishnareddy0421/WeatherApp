//
//  ViewController.swift
//  WeatherApp
//
//  Created by vamsi krishna reddy kamjula on 12/5/17.
//  Copyright © 2017 vamsi krishna reddy kamjula. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift

class ViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var localityLbl: UILabel!
    @IBOutlet weak var summaryLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayLbl: UILabel!
    @IBOutlet weak var todaySV: UIStackView!
    
    let locationManager = CLLocationManager()
    var weekDays : Results<FutureForecast>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.sectionHeaderHeight = 40
        tableView.rowHeight = (tableView.frame.height - 40) / 5
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.white.cgColor
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestLocation()
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemark, error) in
                if error != nil {
                    return
                }
                if let userPlace: CLPlacemark = placemark?[0] {
                    let userLocality = userPlace.locality
                    let userLatitude = userPlace.location?.coordinate.latitude
                    let userLongitude = userPlace.location?.coordinate.longitude
                    
                    UserLocation.instance.gotUserLocation(locality: userLocality!, latitude: userLatitude!, longitude: userLongitude!, completion: { (success) in
                        if success {
                            UIView.animate(withDuration: 0.4, animations: {
                                self.localityLbl.alpha = 1
                                self.temperatureLbl.alpha = 1
                                self.summaryLbl.alpha = 1
                                self.localityLbl.text = "\(userLocality!)"
                                self.temperatureLbl.text = "\(String(describing: "\(UserLocation.instance.locationTemperature!)°"))"
                                self.summaryLbl.text = "\(String(describing: UserLocation.instance.locationSummary!))"
                                self.todaySV.alpha = 1
                                self.todayLbl.text = "\(UserLocation.instance.day!)"
                                
                                self.tableView.alpha = 1
                                self.weekDays = realm.objects(FutureForecast.self)
                                self.tableView.reloadData()
                            })
                        } else {
                            // error handling
                        }
                    })
                }
            })
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied) {
            // error handling
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Day/HighTemperature/LowTemperature"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weekDays != nil {
            return weekDays.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weekDayCell", for: indexPath) as? WeekDaysCell {
         
            cell.dayLbl.text = weekDays[indexPath.row].day
            cell.highTempLbl.text = "\(weekDays[indexPath.row].highTemperature!)°"
            cell.lowTempLbl.text = "\(weekDays[indexPath.row].lowTemperature!)°"
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
