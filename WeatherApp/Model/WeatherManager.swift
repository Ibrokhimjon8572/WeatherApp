//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Ibrohimjon Mamajonov on 16/05/22.
//


import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d0896c32d9aff350344eb9976a844ada&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodeDate = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodeDate.main.temp)
            let id = decodeDate.weather[0].id
            let temp = decodeDate.main.temp
            let name = decodeDate.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temparature: temp)
            return weather
        
        } catch {
            delegate?.didFailError(error: error)
            return nil
        }
    }
}
