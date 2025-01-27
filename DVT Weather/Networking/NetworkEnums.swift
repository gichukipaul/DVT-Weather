//
//  NetworkEnums.swift
//  DVT Weather
//
//  Created by GICHUKI on 27/01/2025.
//

import Foundation

// MARK: - Custom Error Enum
enum WeatherServiceError: Error {
    case networkError(Error)
    case invalidResponse
    case noData
    case decodingError(Error)
    case invalidURL
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server."
        case .noData:
            return "No data received from the server."
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .invalidURL:
            return "The URL was invalid."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
