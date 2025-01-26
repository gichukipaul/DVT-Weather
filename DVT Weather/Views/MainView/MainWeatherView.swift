//
//  MainWeatherView.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

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
        NavigationView {
            VStack(spacing: 0) {
                // Background with Temperature View
                HeaderView(viewModel: viewModel)
                    .frame(width: UIScreen.main.bounds.width, height: 300)
                    .ignoresSafeArea(edges: .top)
                
                // Horizontal Stack: Min, Current, Max Temp
                TemperatureStackView(viewModel: viewModel)
                
                // Forecast Table
                ForecastTableView(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Allow it to use available space
                
                // Buttons for navigating to Favourites or Search Location
                HStack {
                    NavigationLink(destination: FavouritesView()) {
                        Text("View Favourites")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SearchLocationsView()) {
                        Text("Search Locations")
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .background(viewModel.backgroundColor)
            .onAppear(perform: viewModel.setupLocationUpdates)
            .navigationTitle("Weather")
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    MainWeatherView(viewModel: MainWeatherViewModel())
}
