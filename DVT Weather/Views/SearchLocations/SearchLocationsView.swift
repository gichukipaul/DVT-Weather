//
//  SearchLocationsView.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI
import MapKit

struct SearchLocationsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MainWeatherViewModel
    
    @State var region: MKCoordinateRegion
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var errorMessage: String? = nil
    @State private var selectedCoordinates: CLLocationCoordinate2D? = nil
    
    init(viewModel: MainWeatherViewModel) {
        self.viewModel = viewModel
        if let userLocation = viewModel.coordinates {
            _region = State(initialValue: MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 30.0, longitudeDelta: 30.0)
            ))
        } else {
            _region = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.33233141, longitude: -122.0312186), // Default incase the location has not been set yet
                span: MKCoordinateSpan(latitudeDelta: 30.0, longitudeDelta: 30.0)
            ))
        }
    }
    
    var body: some View {
        VStack(spacing: 5) {
            VStack(spacing: 10) {
                // Search Section
                TextField("Enter location name", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.words)
                
                Button(action: searchLocation) {
                    Text("Search Location by Name")
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .foregroundColor(.white)
                        .background(searchText.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(8)
                }
                .disabled(searchText.isEmpty || isSearching)
            }
            
            Divider()
            
            VStack(spacing: 10) {
                // Map Section
                MapView(region: $region, selectedCoordinates: $selectedCoordinates)
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.8)
                
                if selectedCoordinates == nil {
                    Text("Tap on the map to select a location.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Button(action: fetchWeatherFromMap) {
                    Text("Get Weather for Selected Location")
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .foregroundColor(.white)
                        .background(selectedCoordinates == nil ? Color.gray : Color.green)
                        .cornerRadius(8)
                }
                .disabled(selectedCoordinates == nil || isSearching)
            }
            
            if isSearching {
                ProgressView("Fetching Weather Data...")
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .padding()
        .navigationTitle("Search Locations")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func searchLocation() {
        guard !searchText.isEmpty else { return }
        isSearching = true
        errorMessage = nil
        
        viewModel.shouldUseUserLocation = false
        viewModel.fetchWeatherForLocation(searchText) { success in
            DispatchQueue.main.async {
                isSearching = false
                viewModel.isCurrentLocationFavourite = false
                if success {
                    dismiss()
                } else {
                    errorMessage = "Unable to find location. Please try again."
                    viewModel.shouldUseUserLocation = true
                }
            }
        }
    }
    
    private func fetchWeatherFromMap() {
        guard let coordinates = selectedCoordinates else { return }
        isSearching = true
        errorMessage = nil
        
        viewModel.shouldUseUserLocation = false
        viewModel.fetchWeatherForLocation("\(coordinates.latitude), \(coordinates.longitude)") { success in
            DispatchQueue.main.async {
                isSearching = false
                viewModel.isCurrentLocationFavourite = false
                if success {
                    dismiss()
                } else {
                    errorMessage = "Unable to fetch weather for selected location."
                    viewModel.shouldUseUserLocation = true
                }
            }
        }
    }
}
