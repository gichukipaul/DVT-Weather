//
//  MockNetworkService.swift
//  DVT WeatherTests
//
//  Created by GICHUKI on 27/01/2025.
//

import Foundation
@testable import DVT_Weather

// Mock Network Service for unit tests
class MockNetworkService: NetworkServiceProtocol {
    var mockData: Data?
    var mockError: WeatherServiceError?
    
    func requestData(from url: URL, completion: @escaping (Result<Data, WeatherServiceError>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else if let data = mockData {
            completion(.success(data))
        } else {
            completion(.failure(.unknownError))
        }
    }
}
