//
//  WeatherServiceTests.swift
//  DVT WeatherTests
//
//  Created by GICHUKI on 27/01/2025.
//

import XCTest
@testable import DVT_Weather

final class WeatherServiceTests: XCTestCase {
    var weatherService: WeatherService!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        
        // Inject the mock network service into the singleton
        WeatherService.shared.overrideSharedInstance(networkService: mockNetworkService)
        weatherService = WeatherService.shared
    }
    
    override func tearDown() {
        weatherService = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func loadMockJSON(named filename: String) -> Data {
        let bundle = Bundle(for: type(of: self)) // Reference the test bundle
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Could not find \(filename).json in test bundle.")
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Failed to load \(filename).json: \(error.localizedDescription)")
        }
    }
    
    func testFetchCurrentWeather_Success() {
        // Arrange
        let mockWeatherData =  loadMockJSON(named: "weatherResponse")
        mockNetworkService.mockData = mockWeatherData
        
        // Act
        let expectation = self.expectation(description: "Fetch current weather")
        
        weatherService.fetchCurrentWeather(latitude: 37.7749, longitude: -122.4194) { result in
            switch result {
            case .success(let weatherResponse):
                XCTAssertEqual(weatherResponse.weather?.first?.main, "Clouds")
                XCTAssertEqual(weatherResponse.main?.temp, 296.42)
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchCurrentWeather_Failure() {
        // Arrange
        mockNetworkService.mockError = .networkError(NSError(domain: "", code: -1, userInfo: nil))
        
        //Act
        let expectation = self.expectation(description: "Fetch current weather failure")
        
        weatherService.fetchCurrentWeather(latitude: 37.7749, longitude: -122.4194) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Network error: The operation couldn’t be completed. ( error -1.)")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchForecast_Success() {
        // Arrange here
        let mockForecastData = loadMockJSON(named: "forecastResponse")
        mockNetworkService.mockData = mockForecastData
        
        // Act
        let expectation = self.expectation(description: "Fetch forecast")
        
        weatherService.fetchForecast(latitude: 37.7749, longitude: -122.4194) { result in
            switch result {
            case .success(let forecastResponse):
                XCTAssertEqual(forecastResponse.list.first?.main.temp, 296.24)
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchForecast_Failure() {
        // Arrange
        mockNetworkService.mockError = .decodingError(NSError(domain: "", code: -1, userInfo: nil))
        
        // Act
        let expectation = self.expectation(description: "Fetch forecast failure")
        
        weatherService.fetchForecast(latitude: 37.7749, longitude: -122.4194) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Failed to decode the response: The operation couldn’t be completed. ( error -1.)")
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}

