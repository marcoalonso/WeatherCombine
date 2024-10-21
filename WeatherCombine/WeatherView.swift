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
            // Fondo degradado
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(viewModel.locationName)
                    .font(.largeTitle)
                    .padding(.top)
                
                Text(viewModel.currentTemperature)
                    .font(.system(size: 72, weight: .bold))
                    .padding(.top)
                
                Image(systemName: getWeatherIcon(for: viewModel.weatherDescription))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top)
                
                Text(viewModel.weatherDescription)
                    .font(.title)
                    .padding(.bottom)
                
                Divider()
            }
            .foregroundStyle(.white)
        }
        .onAppear {
            viewModel.fetchWeather(for: 19.342, longitude: -101.1234)
        }
    }
    
    func getWeatherIcon(for description: String) -> String {
        switch description.lowercased() {
        case "clear sky":
            return "sun.max.fill"
        case "few clouds":
            return "cloud.sun.fill"
        case "scattered clouds", "broken clouds", "overcast clouds":
            return "cloud.fill"
        case "rain", "light rain", "moderate rain":
            return "cloud.rain.fill"
        case "thunderstorm":
            return "cloud.bolt.fill"
        case "snow":
            return "cloud.snow.fill"
        case "mist":
            return "cloud.fog.fill"
        default:
            return "cloud.fill"
        }
    }
}

