//
//  WeatherView.swift
//  WeatherCombine
//
//  Created by Marco Alonso on 20/10/24.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        ZStack {
            /*
            // Fondo degradado
            LinearGradient(gradient: Gradient(colors: viewModel.isDaytime ? [Color.blue, Color.white] : [Color.black, Color.gray]),
                           startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
                */
            if viewModel.isDaytime {
                GIFImageView(gifName: "clouds_day")
                    .edgesIgnoringSafeArea(.all)
            } else {
                GIFImageView(gifName: "clouds_night")
                    .edgesIgnoringSafeArea(.all)
            }
            VStack {
                // Barra de búsqueda por ciudad
                SearchBar(text: $viewModel.searchQuery) {
                    viewModel.fetchWeatherByCity(city: viewModel.searchQuery)
                }
                
                if viewModel.isSearching {
                    ProgressView("Searching...")
                } else {
                    VStack {
                        Text(viewModel.locationName)
                            .font(.largeTitle)
                            .padding(.top)
                        
                        Text(viewModel.currentTemperature)
                            .font(.system(size: 72, weight: .semibold))
                            .padding(.top)
                        
                        Image(systemName: viewModel.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.top)
                        
                        Text(viewModel.weatherDescription)
                            .font(.title)
                            .padding(.bottom)
                    }
                    .foregroundStyle(.white)
                }
                
                Spacer()
            }
            .onAppear {
                viewModel.fetchWeatherByLocation(latitude: 19.342, longitude: -101.1234)
            }
        }
    }
    
    ///Retornar el nombre de la imagen que voy a mostrar al usuario
    //https://openweathermap.org/weather-conditions
    func getWeatherImage(for id: Int) -> String {
    
        switch id {
        case 200...250:
            return "cloud_bolt"
        case 300...350:
            return "cloud_drizzle"
        case 500...531:
            return "cloud_bolt_rain"
        case 600...622:
            return "cloud_snow"
        case 701...781:
            return "cloud_fog"
        case 800:
            return "sun_max"
        case 801...804:
            // return "cloud_sun"
            return "clouds_day"
        default:
            return "cloud"
        }
    }
    
    
}

#Preview {
    WeatherView()
}
