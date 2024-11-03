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
    
    // Función para obtener el clima por el nombre de la ciudad
    func fetchWeatherByCity(city: String) -> AnyPublisher<WeatherResponse, Error> {
        let urlString = "\(baseURL)?q=\(city)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Función para obtener el clima por coordenadas (latitud y longitud)
    func fetchWeatherByLocation(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponse, Error> {
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


/*
 1. URLSession.shared.dataTaskPublisher(for: url)
 Este es el punto de partida. dataTaskPublisher(for: url) es un método de URLSession (una clase nativa en iOS para hacer solicitudes HTTP). Lo que hace es crear una publicación (Publisher) que realiza una solicitud de red a la URL especificada.

 URLSession.shared: Es una instancia compartida de URLSession que usamos para realizar solicitudes de red.
 dataTaskPublisher(for: url): Crea un publisher (objeto que emite valores) que cuando se suscribe, envía una solicitud HTTP GET al servidor en la URL proporcionada.
 Este Publisher emite un par de valores:

 data: Los datos devueltos por el servidor (la respuesta en formato bruto).
 response: La respuesta HTTP, que incluye el código de estado, encabezados, etc.
 2. .map(\.data)
 El operador .map es un transformador que permite modificar o transformar los valores que emite el publisher.

 map(\.data): Este es un atajo para escribir map { $0.data }. Lo que hace es tomar el par (data, response) que devuelve el dataTaskPublisher, y quedarse solo con la parte de data (es decir, los datos crudos devueltos por la API). La respuesta HTTP (response) no se utiliza aquí.
 En resumen, esta línea transforma el Publisher que emite (data, response) en un Publisher que solo emite data.

 3. .decode(type: WeatherResponse.self, decoder: JSONDecoder())
 El operador .decode(type:decoder:) es otro transformador. Lo que hace es intentar decodificar los datos data (que está en formato JSON) en un tipo de datos Swift.

 type: WeatherResponse.self: Aquí indicamos el tipo al que queremos decodificar los datos, que en este caso es una estructura llamada WeatherResponse. Es decir, estamos diciendo que queremos convertir el JSON que recibimos en un objeto WeatherResponse.

 decoder: JSONDecoder(): Usamos un objeto JSONDecoder para realizar la conversión de los datos JSON en la estructura WeatherResponse. El JSONDecoder está especializado en convertir datos JSON en estructuras Swift que cumplen con el protocolo Codable.

 Si el JSON que obtenemos de la API coincide con la estructura de WeatherResponse, esta línea decodifica los datos JSON en un objeto Swift. Si ocurre un error (por ejemplo, si el JSON no coincide con la estructura), se enviará un error en lugar de un valor decodificado.

 4. .receive(on: DispatchQueue.main)
 El operador .receive(on:) especifica en qué hilo (thread) se recibirán los valores emitidos por el publisher. En este caso, estamos indicando que queremos que las actualizaciones se reciban en el hilo principal (DispatchQueue.main), que es el hilo en el que se realizan las actualizaciones de la interfaz de usuario (UI).

 DispatchQueue.main: Este es el hilo principal de la aplicación, donde se deben hacer todas las actualizaciones de la interfaz de usuario. Usar .receive(on:) garantiza que cualquier actualización posterior en la aplicación relacionada con la UI se realice en el hilo correcto.
 5. .eraseToAnyPublisher()
 El operador .eraseToAnyPublisher() se utiliza para ocultar los detalles del tipo exacto del publisher, devolviendo un AnyPublisher.

 eraseToAnyPublisher(): Esto transforma el publisher en un AnyPublisher. En este contexto, no necesitas exponer el tipo exacto del publisher en la API pública, solo necesitas que se comporte como un publisher genérico que puede emitir un objeto WeatherResponse o un error.
 El AnyPublisher es una versión más abstracta que oculta la complejidad del tipo de publisher que estamos usando y simplemente promete emitir valores del tipo esperado o un error.

 Flujo Completo del Código
 Realiza una solicitud de red a la URL proporcionada con dataTaskPublisher(for:).
 Toma la respuesta de la red y extrae la parte de data (los datos crudos) con map(\.data).
 Decodifica esos datos JSON en una instancia del tipo WeatherResponse con decode(type:decoder:).
 Entrega los resultados (ya sea éxito o error) en el hilo principal de la aplicación con receive(on:), asegurando que cualquier actualización de la interfaz de usuario ocurra en el lugar adecuado.
 Oculta el tipo exacto del publisher devolviendo un AnyPublisher.
 
 Resumen:
 Este bloque de código realiza una solicitud de red asíncrona, procesa la respuesta para decodificarla en un tipo de datos específico (WeatherResponse), y luego entrega el resultado en el hilo principal para que la interfaz de usuario pueda actualizarse de manera segura. Todo el proceso está gestionado de manera reactiva usando Combine.
 */
