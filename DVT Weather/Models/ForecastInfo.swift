//
//  ForecastInfo.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import Foundation
import UIKit

// To retrive specific data from the ForecastResponse object in a clean manner
struct ForecastInfo: Hashable {
    let forecastDate: String
    let dayOfWeek: String
    let time: String
    let weather: String
    let temp: String
    let weatherIcon: UIImage
}
