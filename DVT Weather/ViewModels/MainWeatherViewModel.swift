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
    
    private var cancellables: Set<AnyCancellable> = []

    private let weatherService = WeatherService.shared
    private var locationManager = LocationManager()

    init() {
        locationManager.$location
            .sink { [weak self] newCoordinates in
                self?.coordinates = newCoordinates
                if let coords = newCoordinates {
                    self?.fetchWeatherData(latitude: coords.latitude, longitude: coords.longitude)
                }
            }
            .store(in: &cancellables)
    }

    private func fetchWeatherData(latitude: Double, longitude: Double) {
        fetchCurrentWeather(latitude: latitude, longitude: longitude)
        fetchForecast(latitude: latitude, longitude: longitude)
        print("fetched current and forecast with lat: \(latitude) and lon \(longitude)")
    }

    private func fetchCurrentWeather(latitude: Double, longitude: Double) {
        weatherService.fetchCurrentWeather(latitude: latitude, longitude: longitude) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.currentWeather = weather
                    print("\(String(describing: weather))")
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
                    // Directly extract forecast data
                    self?.forecasts = Utilities.extractDailyForecast(from: forecast)
                    print("forecast here")
                    self?.forecastResponse = forecast // Store the full response as well if needed
                case .failure(let error):
                    self?.errorMessage = "Error fetching forecast: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func setupLocationUpdates() {
        locationManager.requestLocation()
    }
}

