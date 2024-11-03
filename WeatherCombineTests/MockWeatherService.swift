//
//  MockWeatherService.swift
//  WeatherCombineTests
//
//  Created by Marco Alonso on 03/11/24.
//

import XCTest
import Combine
@testable import WeatherCombine

class MockWeatherService: WeatherService {
    var shouldReturnError = false
    var mockResponse: WeatherResponse?
    
    override func fetchWeatherByCity(city: String) -> AnyPublisher<WeatherResponse, Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        
        if let response = mockResponse {
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    
    override func fetchWeatherByLocation(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponse, Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        
        if let response = mockResponse {
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
}


