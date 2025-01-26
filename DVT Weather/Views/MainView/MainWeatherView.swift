//
//  MainWeatherView.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI
import Combine

import SwiftUI
import Combine

struct MainWeatherView: View {
    @StateObject var locationManager = LocationManager()
    @ObservedObject var viewModel: MainWeatherViewModel
    @State private var isFavorite: Bool = false
    
    @State private var latitude: Double? = nil
    @State private var longitude: Double? = nil
    
    init(viewModel: MainWeatherViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Background with Temperature View
            HStack {
                ZStack {
                    Image("forest_sunny")
                        .resizable()
                        .scaledToFill()
                    
                    // Temperature View centered on the background
                    TemperatureView(viewModel: viewModel)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 300)
            .ignoresSafeArea(edges: .top)
            
            // Horizontal Stack: Min, Current, Max Temp
            TemperatureStackView(viewModel: viewModel)
            
            // Forecast Table
            ForecastTableView(viewModel: viewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Allow it to use available space
            
            // Buttons for navigating to Favourites or Search Location
            HStack {
                Button(action: navigateToFavourites) {
                    Text("View Favourites")
                        .font(.body)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Button(action: openSearchLocation) {
                    Text("Search Locations")
                        .font(.body)
                        .foregroundColor(.blue)
                }
            }
            .padding([.horizontal, .bottom])
        }
        .onAppear(perform: viewModel.setupLocationUpdates)
    }
    
    private func navigateToFavourites() {
        // Navigation logic
    }
    
    private func openSearchLocation() {
        // Search location view logic
    }
}

#Preview {
    MainWeatherView(viewModel: MainWeatherViewModel())
}
