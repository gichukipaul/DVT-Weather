//
//  MainWeatherViewModel.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI
import Combine
import CoreLocation

class MainWeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherResponse?
    @Published var forecastResponse: ForecastResponse?
    @Published var coordinates: CLLocationCoordinate2D?
    @Published var forecasts: [ForecastInfo]? = []
    @Published var errorMessage: String?
    @Published var favouriteLocations: [FavouriteLocation] = []
    
    // UI-related properties
    @Published var backgroundImage: String = "forest_sunny"
    @Published var backgroundColor: Color = Color("sunny")
    @Published var shouldUseUserLocation: Bool = true // Toggle for location updates
    @Published var isCurrentLocationFavourite: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    private let weatherService = WeatherService.shared
    private var locationManager = LocationManager()
    
    init() {
        // Bind location updates to weather fetching
        locationManager.$location
            .sink { [weak self] newCoordinates in
                guard let self = self, self.shouldUseUserLocation else { return }
                self.coordinates = newCoordinates
                if let coords = newCoordinates {
                    self.fetchWeatherData(latitude: coords.latitude, longitude: coords.longitude)
                }
            }
            .store(in: &cancellables)
        
        // Update UI-related properties whenever `currentWeather` changes
        $currentWeather
            .compactMap { $0?.weather?.first?.main }
            .sink { [weak self] weatherMain in
                self?.updateWeatherMode(for: weatherMain)
                self?.updateIsCurrentLocationFavourite()
            }
            .store(in: &cancellables)
    }
    
    func fetchWeatherForLocation(_ location: String, completion: @escaping (Bool) -> Void) {
        // Disable location updates temporarily
        shouldUseUserLocation = false
        isCurrentLocationFavourite = false
        
        let geocodingService = GeocodingService()
        geocodingService.getCoordinates(for: location) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coordinates):
                    print("Coordinates for \(location): \(coordinates.latitude), \(coordinates.longitude)")
                    self?.fetchWeatherData(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    
                    // Mark the current location as NOT a favorite by default
                    self?.isCurrentLocationFavourite = false
                    
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch location: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
    }
    
    private func fetchWeatherData(latitude: Double, longitude: Double) {
        fetchCurrentWeather(latitude: latitude, longitude: longitude)
        fetchForecast(latitude: latitude, longitude: longitude)
    }
    
    private func fetchCurrentWeather(latitude: Double, longitude: Double) {
        weatherService.fetchCurrentWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.currentWeather = weather
                case .failure(let error):
                    self?.errorMessage = "Error fetching weather: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func fetchForecast(latitude: Double, longitude: Double) {
        weatherService.fetchForecast(latitude: latitude, longitude: longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let forecast):
                    self?.forecastResponse = forecast
                    self?.forecasts = Utilities.extractDailyForecast(from: forecast)
                case .failure(let error):
                    self?.errorMessage = "Error fetching forecast: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func updateWeatherMode(for weatherMain: String) {
        switch weatherMain.lowercased() {
        case "clear":
            backgroundColor = Color("sunny")
            backgroundImage = "forest_sunny"
        case "rain":
            backgroundColor = Color("rainy")
            backgroundImage = "forest_rainy"
        case "clouds":
            backgroundColor = Color("cloudy")
            backgroundImage = "forest_cloudy"
        default:
            backgroundColor = Color("cloudy")
            backgroundImage = "forest_cloudy"
        }
    }
    
    func toggleFavourite() {
        guard let currentWeather = currentWeather else { return }
        
        if isCurrentLocationFavourite {
            // Remove from favorites
            favouriteLocations.removeAll {
                $0.latitude == currentWeather.coord.lat && $0.longitude == currentWeather.coord.lon
            }
        } else {
            // Add to favorites
            favouriteLocations.append(FavouriteLocation(
                name: currentWeather.name ?? "",
                latitude: currentWeather.coord.lat,
                longitude: currentWeather.coord.lon, weatherData: currentWeather
            ))
        }
        
        // Toggle the favorite state
        isCurrentLocationFavourite.toggle()
    }
    
    
    private var currentFavouriteLocation: FavouriteLocation? {
        guard let currentWeather = currentWeather else { return nil }
        return favouriteLocations.first(where: {
            $0.latitude == currentWeather.coord.lat && $0.longitude == currentWeather.coord.lon
        })
    }
    
    private func addFavourite(location: FavouriteLocation) {
        if !favouriteLocations.contains(where: { $0.id == location.id }) {
            favouriteLocations.append(location)
        }
    }
    
    private func removeFavourite(id: UUID) {
        favouriteLocations.removeAll { $0.id == id }
    }
    
    private func addFavouriteWithCurrentWeather() {
        guard let currentWeather = currentWeather else { return }
        
        let location = FavouriteLocation(
            name: currentWeather.name ?? "Unknown",
            latitude: currentWeather.coord.lat,
            longitude: currentWeather.coord.lon,
            weatherData: currentWeather
        )
        
        addFavourite(location: location)
    }
    
    // Updates  the `isCurrentLocationFavourite` based on the current weather data.
    private func updateIsCurrentLocationFavourite() {
        guard let currentWeather = currentWeather else {
            isCurrentLocationFavourite = false
            return
        }
        isCurrentLocationFavourite = favouriteLocations.contains {
            $0.latitude == currentWeather.coord.lat && $0.longitude == currentWeather.coord.lon
        }
    }
    
    func setupLocationUpdates() {
        locationManager.requestLocation()
    }
}
