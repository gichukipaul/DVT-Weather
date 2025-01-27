//
//  WeatherService.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import Foundation
import Combine

class WeatherService: WeatherServiceProtocol {
    private let networkService: NetworkServiceProtocol
    var apiKey: String
    
    // Singleton
    static var shared: WeatherService = WeatherService(networkService: NetworkService.shared, apiKey: Bundle.main.weatherAPIKey ?? "API KEY")
    
    private init(networkService: NetworkServiceProtocol, apiKey: String) {
        self.networkService = networkService
        self.apiKey = apiKey
    }
    
    // A testable initializer for UNIT testing
    func overrideSharedInstance(networkService: NetworkServiceProtocol) {
        WeatherService.shared = WeatherService(networkService: networkService, apiKey: self.apiKey)
    }
    
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, WeatherServiceError>) -> Void) {
        let url = constructURL(endpoint: "weather", latitude: latitude, longitude: longitude)
        
        networkService.requestData(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    print("here with weather")
                    print(String(describing: weather))
                    
                    completion(.success(weather))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchForecast(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastResponse, WeatherServiceError>) -> Void) {
        let url = constructURL(endpoint: "forecast", latitude: latitude, longitude: longitude)
        
        networkService.requestData(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                    completion(.success(forecastResponse))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func constructURL(endpoint: String, latitude: Double, longitude: Double) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/\(endpoint)"
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: apiKey),  // Use the API key here
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components.url else {
            // Handle invalid URL more gracefully
            return URL(string: "")!
        }
        return url
    }
}
