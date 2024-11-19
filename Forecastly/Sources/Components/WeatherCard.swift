//
//  WeatherCard.swift
//  Forecastly
//
//  Created by Luis Amorim on 19/11/2024.
//

import SwiftUI

struct WeatherCard: View {
    let icon: String         // Weather condition icon
    let description: String  // Weather condition description
    let temperature: String  // Current temperature
    let feelsLike: String    // Feels-like temperature
    let humidity: String     // Humidity percentage
    let wind: String         // Wind speed and direction

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Weather Icon and Description
            HStack {
                Image(systemName: icon) // Dynamic icon
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text(description) // Dynamic description
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
            }

            // Temperature Information
            Text("Temperature: \(temperature)°C")
                .font(.headline)
                .foregroundColor(.white)

            // Additional Details
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Feels Like: \(feelsLike)")
                    Text("Humidity: \(humidity)")
                    Text("Wind: \(wind)")
                }
                .foregroundColor(.white)
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.accentColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ).opacity(0.9)
                )
        )
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
