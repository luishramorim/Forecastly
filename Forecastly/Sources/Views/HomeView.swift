//
//  HomeView.swift
//  Forecastly
//
//  Created by Luis Amorim on 19/11/2024.
//

import SwiftUI
import CoreLocation
import MapKit
import WeatherKit

struct HomeView: View {
    @State private var city: String = "Unknown" // User's city
    @State private var country: String = "Unknown" // User's country
    @State private var stateText: String = "Fetching location..." // State message
    @State private var isLoading: Bool = true // Loading state
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ) // Map region for user's location
    @State private var trackingMode: MapUserTrackingMode = .follow // Tracking mode for the map

    @State private var weatherData: CurrentWeather? // Weather data fetched from WeatherKit

    private let locationService = LocationService() // Instance of LocationService
    private let weatherService = WeatherService() // Instance of WeatherKit's WeatherService

    var body: some View {
        ZStack {
            // Fullscreen map
            Map(coordinateRegion: $region, interactionModes: [], showsUserLocation: true, userTrackingMode: $trackingMode)
                .ignoresSafeArea(edges: .all)

            VStack(spacing: 20) {
                LocationCard(city: city, country: country) // Dynamic LocationCard

                if let weather = weatherData {
                    WeatherCard(
                        icon: weather.symbolName,
                        description: weather.condition.description,
                        temperature: "\(weather.temperature.value.formatted(.number.precision(.fractionLength(1))))°\(weather.temperature.unit.symbol)",
                        feelsLike: "\(weather.apparentTemperature.value.formatted(.number.precision(.fractionLength(1))))°\(weather.temperature.unit.symbol)",
                        humidity: "\((weather.humidity * 100).formatted(.number.precision(.fractionLength(1))))%",
                        wind: "\(Int(weather.wind.speed.value)) \(weather.wind.compassDirection.description)"
                    )
                } else {
                    Text("Fetching weather...")
                        .foregroundColor(.white)
                        .padding()
                }

                Spacer()
            }
            .padding()
        }
        .task {
            // Fetch location and address, then weather data
            await fetchLocationAndWeather()
        }
    }

    // Fetch location and weather data
    private func fetchLocationAndWeather() async {
        isLoading = true
        stateText = "Fetching location..."
        
        locationService.requestAddress { fetchedCity, fetchedCountry, error in
            if let error = error {
                stateText = "Cannot get your location. \n \(error.localizedDescription)"
                isLoading = false
            } else if let fetchedCity = fetchedCity, let fetchedCountry = fetchedCountry {
                DispatchQueue.main.async {
                    city = fetchedCity
                    country = fetchedCountry
                }

                // Fetch weather data once location is available
                locationService.requestLocation { coordinate, locationError in
                    if let coordinate = coordinate, locationError == nil {
                        Task {
                            await fetchWeather(for: coordinate)
                        }
                    } else {
                        stateText = "Cannot fetch weather. \n \(locationError?.localizedDescription ?? "Unknown error.")"
                    }
                }
            }
        }
    }

    // Fetch weather data from WeatherKit
    private func fetchWeather(for coordinate: CLLocationCoordinate2D) async {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        do {
            let weather = try await weatherService.weather(for: location)
            DispatchQueue.main.async {
                self.weatherData = weather.currentWeather
            }
        } catch {
            DispatchQueue.main.async {
                stateText = "Failed to fetch weather data. \n \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    HomeView()
}
