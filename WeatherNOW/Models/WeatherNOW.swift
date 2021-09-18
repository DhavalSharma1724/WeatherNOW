//
//  Weather.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/13/21.
//

import Foundation

class WeatherNOW: Decodable, Identifiable, ObservableObject{
    var lat: Double
    var lon: Double
    var timezone: String
    var timezone_offset: Int
    var current: Current
    var hourly: [Hourly]
    var daily: [Daily]
}

class Current: Decodable, Identifiable, ObservableObject{
    var dt: Int
    var sunrise: Int = 0
    var sunset: Int
    var temp: Double
    var feels_like: Double
    var pressure: Int
    var humidity: Int
    var dew_point: Double
    var uvi: Double
    var clouds: Int
    var visibility: Int
    var wind_speed: Double
    var wind_deg: Int
    var wind_gust: Double?
    var weather: [Weather]
    
}

class Weather: Decodable, Identifiable, ObservableObject{
    var id: Int
    var main: String
    var description: String
    var icon: String
}

class Hourly: Decodable, Identifiable, ObservableObject{
    var dt: Int
    var temp: Double
    var feels_like: Double
    var pressure: Int
    var humidity: Int
    var dew_point: Double
    var uvi: Double
    var clouds: Int
    var visibility: Int
    var wind_speed: Double
    var wind_gust: Double?
    var wind_deg: Int
    var pop: Double
    var weather: [Weather]
}

class Daily: Decodable, Identifiable, ObservableObject{
    var dt: Int
    var sunrise: Int
    var sunset: Int
    var moonrise: Int
    var moonset: Int
    var moon_phase: Double
    var temp: Temperature
    var feels_like: FeelsLike
    var pressure: Int
    var humidity: Int
    var dew_point: Double
    var wind_speed: Double
    var wind_gust: Double?
    var wind_deg: Int
    var weather: [Weather]
    var clouds: Int
    var pop: Double
    var rain: Double?
    var snow: Double?
    var uvi: Double
}

class Temperature: Decodable, Identifiable, ObservableObject{
    var day: Double
    var min: Double
    var max: Double
    var night: Double
    var eve: Double
    var morn: Double
}

class FeelsLike: Decodable, Identifiable, ObservableObject{
    var day: Double
    var night: Double
    var eve: Double
    var morn: Double
}

