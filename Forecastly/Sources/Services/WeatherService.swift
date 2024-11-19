//
//  WeatherServiceHelper.swift
//  Forecastly
//
//  Created by Luis Amorim on 19/11/2024.
//

import Foundation
import WeatherKit
import CoreLocation

class WeatherServiceHelper {
    private let weatherService = WeatherService()

    // Fetch current weather for a given location
    func fetchCurrentWeather(for coordinate: CLLocationCoordinate2D) async throws -> CurrentWeather {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let weather = try await weatherService.weather(for: location)
        return weather.currentWeather
    }
}
