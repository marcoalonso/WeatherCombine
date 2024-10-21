//
//  WeatherViewModel.swift
//  WeatherCombine
//
//  Created by Marco Alonso on 20/10/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var currentTemperature: String = "--"
    @Published var weatherDescription: String = ""
    @Published var locationName: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let weatherService = WeatherService()
    
    func fetchWeather(for latitude: Double, longitude: Double) {
        weatherService.fetchCurrentWeather(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching weather: \(error)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.currentTemperature = "\(Int(response.main.temp))°C"
                self.weatherDescription = response.weather.first?.description.capitalized ?? ""
                self.locationName = response.name
            })
            .store(in: &cancellables)
    }
}
