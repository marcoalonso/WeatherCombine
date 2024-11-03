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
    @Published var weatherId: Int = 800
    @Published var locationName: String = ""
    @Published var searchQuery: String = ""  // Para la búsqueda por ciudad
    @Published var isSearching: Bool = false // Estado de búsqueda
    @Published var isDaytime: Bool = true
    @Published var imageName: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherService
    private let locationManager: LocationManager
    
    // Inicializador que permite la inyección de dependencias
    init(weatherService: WeatherService = WeatherService(),
         locationManager: LocationManager = LocationManager()) {
        self.weatherService = weatherService
        self.locationManager = locationManager
        setupLocationSubscription()
    }
    
    private func setupLocationSubscription() {
        locationManager.$currentLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.fetchWeatherByLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            }
            .store(in: &cancellables)
    }
    
    // Método para buscar el clima por ciudad
    func fetchWeatherByCity(city: String) {
        isSearching = true
        weatherService.fetchWeatherByCity(city: city)
            .sink(receiveCompletion: { completion in
                self.isSearching = false
                if case .failure(let error) = completion {
                    print("Error fetching weather: \(error)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.updateWeatherData(response: response)
                self.isSearching = false
            })
            .store(in: &cancellables)
    }
    
    // Método para buscar el clima por coordenadas
    func fetchWeatherByLocation(latitude: Double, longitude: Double) {
        isSearching = true
        weatherService.fetchWeatherByLocation(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { completion in
                self.isSearching = false
                if case .failure(let error) = completion {
                    print("Error fetching weather: \(error)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.updateWeatherData(response: response)
                self.isSearching = false
            })
            .store(in: &cancellables)
    }
    
    // Método auxiliar para actualizar los datos del clima
    private func updateWeatherData(response: WeatherResponse) {
        self.currentTemperature = "\(Int(response.main.temp))°C"
        self.weatherDescription = response.weather.first?.description.capitalized ?? ""
        self.locationName = response.name
        self.weatherId = response.weather.first?.id ?? 800
        checkIfDaytime()
        getWeatherIcon()
    }
    
    private func checkIfDaytime() {
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: Date())
        
        // Si la hora es después de las 7 PM o antes de las 8 AM, es de noche
        if currentHour >= 19 || currentHour < 8 {
            self.isDaytime = false
        } else {
            self.isDaytime = true
        }
    }
    
    private func getWeatherIcon() {
        switch weatherId {
        case 200...232:
            imageName = "cloud.bolt.fill"
        case 300...350:
            imageName = "cloud.rain.fill"
        case 500...532:
            imageName = "cloud.sun.rain"
        case 600...650:
            imageName = "cloud.snow"
        case 700...750:
            imageName = "tornado"
        case 800:
            imageName = "sun.max"
        case 801:
            imageName = "cloud.sun"
        case 802:
            imageName = "cloud.sun"
        case 803:
            imageName = "icloud.fill"
        case 804:
            imageName = "icloud.fill"
        default:
            imageName = "cloud"
        }
    }
}

