//
//  FavouriteLocation.swift
//  DVT Weather
//
//  Created by GICHUKI on 27/01/2025.
//

import Foundation

struct FavouriteLocation: Identifiable, Codable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let weatherData: WeatherResponse
}
