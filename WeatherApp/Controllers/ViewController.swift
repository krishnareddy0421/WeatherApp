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

class ViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var localityLbl: UILabel!
    @IBOutlet weak var summaryLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                            })
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
