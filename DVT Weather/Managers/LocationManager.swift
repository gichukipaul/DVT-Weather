//
//  LocationManager.swift
//  DVT Weather
//
//  Created by GICHUKI on 25/01/2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestLocation() {
        startUpdatingLocation()
    }
    
    private func startUpdatingLocation() {
        isLoading = true
        locationManager.startUpdatingLocation()
    }
    
    // Handle changes in location authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location access granted.")
            startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied. Please enable it in Settins")
        case .notDetermined:
            print("Location access not determined. Please check in Settings")
        @unknown default:
            print("Unknown location status.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastlocation = locations.last else {
            print("Location error: No location was found")
            isLoading = false
            return
        }
        location = lastlocation.coordinate
        print("\(String(describing: location))")
        locationManager.stopUpdatingLocation()
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location error: \(error.localizedDescription)")
        isLoading = false
    }
}
