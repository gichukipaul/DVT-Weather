//
//  WeatherServiceProtocol.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import Foundation

protocol WeatherServiceProtocol {
    var apiKey: String { get }
    func fetchCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, WeatherServiceError>) -> Void)
    func fetchForecast(latitude: Double, longitude: Double, completion: @escaping (Result<ForecastResponse, WeatherServiceError>) -> Void)
}
