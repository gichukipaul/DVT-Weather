//
//  Utilities.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import Foundation
import UIKit

public class Utilities {
    static func extractDailyForecast(from response: ForecastResponse) -> [ForecastInfo] {
        var dailyForecasts: [String: ForecastList] = [:]
        let targetTime = "12:00:00" // Preferred time for daily forecast
        
        for forecast in response.list {
            let dateComponents = forecast.dtTxt.split(separator: " ")
            guard dateComponents.count == 2 else { continue }
            
            let dayKey = String(dateComponents[0]) // Extract "yyyy-MM-dd"
            let timePart = String(dateComponents[1])
            
            // Replace the existing forecast if it doesn't meet target time
            if dailyForecasts[dayKey] == nil || timePart == targetTime {
                dailyForecasts[dayKey] = forecast
            }
        }
        
        // Sort by date key
        let sortedForecasts = dailyForecasts.sorted { lhs, rhs in
            guard let lhsDate = DateFormatter.dateFormatter.date(from: lhs.key),
                  let rhsDate = DateFormatter.dateFormatter.date(from: rhs.key) else {
                return false
            }
            return lhsDate < rhsDate
        }
        
        // Map to ForecastInfo and include the day of the week
        return sortedForecasts.map { _, forecast in
            guard let date = DateFormatter.dateFormatter.date(from: forecast.dtTxt) else {
                fatalError("Invalid date format in forecast: \(forecast.dtTxt)")
            }
            
            let day = DateFormatter.dayOfWeek.string(from: date)
            let timeComponents = forecast.dtTxt.split(separator: " ")
            let time = timeComponents.count > 1 ? String(timeComponents[1]) : "Unknown"
            let weatherDescription = forecast.weather.first?.description.capitalized ?? "Unknown"
            
            return ForecastInfo(
                forecastDate: String(forecast.dtTxt.prefix(10)),
                dayOfWeek: day,
                time: time,
                weather: weatherDescription,
                temp: "\(Int(forecast.main.temp))°",
                weatherIcon: getWeatherIcon(weather: weatherDescription)
            )
        }
    }

    
    static func getWeatherIcon(weather: String) -> UIImage {
        if weather.contains(WeatherType.Sunny.rawValue) {
            return UIImage(named: "partlysunny")!
        } else if weather.contains(WeatherType.Rainy.rawValue) {
            return UIImage(named: "rain")!
        } else if weather.contains(WeatherType.Cloudy.rawValue) {
            return UIImage(systemName: "cloud.fill")!
        } else {
            return UIImage(named: "clear")!
        }
    }
}

enum WeatherType: String {
    case Sunny = "Sun"
    case Rainy = "Rain"
    case Cloudy = "Cloud"
}

enum WeatherMode {
    case sunny
    case rainy
    case cloudy
}
