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
    
    // UI-related properties
    @Published var backgroundImage: String = "forest_sunny"
    @Published var backgroundColor: Color = Color("sunny")
    
    private var cancellables: Set<AnyCancellable> = []
    private let weatherService = WeatherService.shared
    private var locationManager = LocationManager()
    
    init() {
        // Bind location updates to weather fetching
        locationManager.$location
            .sink { [weak self] newCoordinates in
                self?.coordinates = newCoordinates
                if let coords = newCoordinates {
                    self?.fetchWeatherData(latitude: coords.latitude, longitude: coords.longitude)
                }
            }
            .store(in: &cancellables)
        
        // Update UI-related properties whenever `currentWeather` changes
        $currentWeather
            .compactMap { $0?.weather?.first?.main }
            .sink { [weak self] weatherMain in
                self?.updateWeatherMode(for: weatherMain)
            }
            .store(in: &cancellables)
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
    
    func setupLocationUpdates() {
        locationManager.requestLocation()
    }
}
