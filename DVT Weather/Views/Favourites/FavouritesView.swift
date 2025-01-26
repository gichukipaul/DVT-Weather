//
//  FavouritesView.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI

struct FavouritesView: View {
    @ObservedObject var viewModel: MainWeatherViewModel
    
    var body: some View {
        VStack {
            if viewModel.favouriteLocations.isEmpty {
                Text("No favourites yet.")
                    .font(.title2)
                    .foregroundColor(.gray)
            } else {
                List(viewModel.favouriteLocations) { location in
                    VStack(alignment: .leading) {
                        Text(location.name)
                            .font(.headline)
                        Text("Temperature: \(location.weatherData.main?.temp ?? 0, specifier: "%.1f")°C")
                        Text("Conditions: \(location.weatherData.weather?.first?.description ?? "N/A")")
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle("Favourites")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FavouritesView(viewModel: MainWeatherViewModel())
}
