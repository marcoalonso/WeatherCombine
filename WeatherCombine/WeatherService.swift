//
//  WeatherService.swift
//  WeatherCombine
//
//  Created by Marco Alonso on 20/10/24.
//
//    private let apiKey = "43c02b88939bc65afefdef7ff3b31822"
import Foundation
import Combine

class WeatherService {
    private let apiKey = "43c02b88939bc65afefdef7ff3b31822"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func fetchCurrentWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponse, Error> {
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

    
    
    
