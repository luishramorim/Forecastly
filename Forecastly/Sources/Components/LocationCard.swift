//
//  LocationCard.swift
//  Forecastly
//
//  Created by Luis Amorim on 19/11/2024.
//

import SwiftUI

struct LocationCard: View {
    let city: String         // City name
    let country: String      // Country name

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                VStack(alignment: .leading){
                    // Location Title
                    HStack{
                        Image(systemName: "location.circle")
                        Text("\(city), \(country)")
                    }
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity) // Make the card fill the width of the screen
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
        .padding(.horizontal) // Add horizontal padding for spacing
    }
}

#Preview {
    LocationCard(city: "Paris", country: "France")
}
