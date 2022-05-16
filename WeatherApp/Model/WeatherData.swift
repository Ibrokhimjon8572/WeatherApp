//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Ibrohimjon Mamajonov on 16/05/22.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
