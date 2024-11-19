//
//  LocationService.swift
//  Forecastly
//
//  Created by Luis Amorim on 19/11/2024.
//

import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var locationCompletion: ((CLLocationCoordinate2D?, Error?) -> Void)?
    private var addressCompletion: ((String?, String?, Error?) -> Void)?
    private var lastFetchedLocation: CLLocation?

    override init() {
        super.init()
        configureLocationManager()
    }

    // MARK: - Public Methods
    func requestLocation(completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        locationCompletion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func requestAddress(completion: @escaping (String?, String?, Error?) -> Void) {
        addressCompletion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    // MARK: - Private Methods
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                self?.addressCompletion?(nil, nil, error)
                return
            }
            if let placemark = placemarks?.first {
                let city = placemark.locality
                let country = placemark.country
                self?.addressCompletion?(city, country, nil)
            } else {
                self?.addressCompletion?(nil, nil, NSError(domain: "LocationService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve address"]))
            }
        }
    }

    private func shouldFetchAddress(for location: CLLocation) -> Bool {
        guard let lastLocation = lastFetchedLocation else { return true }
        let distance = location.distance(from: lastLocation)
        return distance > 500 // Only fetch address if user moved > 500 meters
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Handle location coordinate
        locationCompletion?(location.coordinate, nil)

        // Reverse geocode only if needed
        if shouldFetchAddress(for: location) {
            lastFetchedLocation = location
            reverseGeocode(location: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(nil, error)
        addressCompletion?(nil, nil, error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            let error = NSError(domain: "LocationService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location access denied."])
            locationCompletion?(nil, error)
            addressCompletion?(nil, nil, error)
        }
    }
}
