//
//  NetworkService.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    // Private static variable for the singleton instance
    static let shared = NetworkService()
    
    // Private initializer to prevent instantiation from outside
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    func requestData(from url: URL, completion: @escaping (Result<Data, WeatherServiceError>) -> Void) {
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
