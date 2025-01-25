//
//  LocationHelper.swift
//  Group_06_Events
//
//  Created by Darren Eddy on 2024-03-11.
//

import Foundation
import CoreLocation
import Contacts

class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate{
    // ObservableObject: Combine framework’s type for an object with a publisher that emits before the object has changed.
    // The methods that you use to receive events from an associated location-manager object.
    
    private let geoCoder = CLGeocoder()
    // An interface for converting between geographic coordinates and place names.
    
    private let locationManager = CLLocationManager()
    //The object that you use to start and stop the delivery of location-related events to your app.
    
    @Published var authorizationStatus : CLAuthorizationStatus = .notDetermined
    // Constants indicating the app's authorization to use location services.
    
    @Published var currentLocation: CLLocation?
    //The latitude, longitude, and course information reported by the system.
    
    override init() {
        super.init()
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //The best level of accuracy available.
            
        }
        // permission check
        self.checkPermission()
        
        if (CLLocationManager.locationServicesEnabled() && (self.authorizationStatus == .authorizedAlways || self.authorizationStatus == .authorizedWhenInUse)){
            self.locationManager.startUpdatingLocation()
        }else{
            self.requestPermission()
        }
        
    }// init
 
    func requestPermission(){
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.requestWhenInUseAuthorization()
            //Requests the user’s permission to use location services while the app is in use.
        }
    }
    
    func checkPermission(){
        switch self.locationManager.authorizationStatus{
        case .denied:
            // req perm
            self.requestPermission()
            
        case .notDetermined:
            self.requestPermission()
            
        case .restricted:
            self.requestPermission()
            
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
            
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            
        default:
            break

        }
    }//checkPerm
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "Authorization Status changed : \(self.locationManager.authorizationStatus)")
        
        self.authorizationStatus = manager.authorizationStatus
    }

    func doForwardGeocoding(address : String, completionHandler: @escaping(CLLocation?, NSError?) -> Void){
        self.geoCoder.geocodeAddressString(address, completionHandler: {
            (placemarks, error) in
            if (error != nil){
                print(#function, "Unable to obtain coord for the given address \(error)")
                completionHandler(nil, error as NSError?)
            }else{
                if let place = placemarks?.first{
                    let matchedLocation = place.location
                    print(#function, "matchedLocation: \(matchedLocation)")
                    completionHandler(matchedLocation, nil)
                    return
                }
                completionHandler(nil, error as NSError?)
            }
        })
    }//doforward()
    

    
    
}
