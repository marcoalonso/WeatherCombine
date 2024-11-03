//
//  WeatherViewModelTests.swift
//  WeatherCombineTests
//
//  Created by Marco Alonso on 03/11/24.
//

import XCTest
import Combine
@testable import WeatherCombine

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchWeatherByCity_Success() {
        let expectedTemperature = "25°C"
        let expectedDescription = "Clear"
        
        mockWeatherService.mockResponse = loadMockWeatherResponse()
        
        let expectation = XCTestExpectation(description: "Fetch weather by city")
        
        viewModel.fetchWeatherByCity(city: "Test City")
        
        viewModel.$currentTemperature
            .sink { temperature in
                XCTAssertEqual(temperature, expectedTemperature)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchWeatherByCity_Error() {
        mockWeatherService.shouldReturnError = true
        
        let expectation = XCTestExpectation(description: "Handle error")
        
        viewModel.fetchWeatherByCity(city: "Test City")
        
        viewModel.$isSearching
            .sink { isSearching in
                XCTAssertFalse(isSearching)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testUpdateWeatherIcon_Sunny() {
        mockWeatherService.mockResponse = loadMockWeatherResponse()
        
        let expectation = XCTestExpectation(description: "Update weather icon")
        
        viewModel.fetchWeatherByCity(city: "Test City")
        
        viewModel.$imageName
            .sink { imageName in
                XCTAssertEqual(imageName, "sun.max")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testCheckIfDaytime_NightTime() {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: Date())
        let isDaytime = currentHour >= 8 && currentHour < 19
        
        XCTAssertEqual(viewModel.isDaytime, isDaytime)
    }
    
    func testFetchWeatherByLocation_Success() {
        let expectedTemperature = "18°C"
        let expectedDescription = "Cloudy"
        
        mockWeatherService.mockResponse = loadMockWeatherResponse()
        
        let expectation = XCTestExpectation(description: "Fetch weather by location")
        
        viewModel.fetchWeatherByLocation(latitude: 19.342, longitude: -101.1234)
        
        viewModel.$currentTemperature
            .sink { temperature in
                XCTAssertEqual(temperature, expectedTemperature)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }

    // Decodificar JSON mock a un objeto WeatherResponse para usar en las pruebas
    func loadMockWeatherResponse() -> WeatherResponse {
        let json = """
        {
          "coord": {
            "lon": -101.1234,
            "lat": 19.342
          },
          "weather": [
            {
              "main": "Clear",
              "description": "clear sky",
              "icon": "01d",
              "id": 800
            }
          ],
          "main": {
            "temp": 25.0,
            "feels_like": 26.5,
            "temp_min": 22.0,
            "temp_max": 28.0,
            "pressure": 1013,
            "humidity": 40
          },
          "wind": {
            "speed": 5.1,
            "deg": 180,
            "gust": 7.6
          },
          "clouds": {
            "all": 0
          },
          "sys": {
            "country": "MX",
            "sunrise": 1632998987,
            "sunset": 1633042287
          },
          "name": "Test City"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        do {
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: json)
            return weatherResponse
        } catch {
            fatalError("Error decoding JSON mock: \(error)")
        }
    }

}


