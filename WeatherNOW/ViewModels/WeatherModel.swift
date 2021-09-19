//
//  WeatherModel.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/13/21.
//

import Foundation
import CoreLocation
import SwiftUI

class WeatherModel: NSObject, CLLocationManagerDelegate, ObservableObject{
    var locationManager = CLLocationManager()
    
    @Published var weatherImp: WeatherNOW?
    @Published var weatherMet: WeatherNOW?
    @Published var placemark: CLPlacemark?
    @Published var imperial = true
    var hourlyTime = [String]()
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    var topics = ["UV Index", "Wind Speed", "Humidity", "Clouds", "Dew Point"]
    
    override init(){
        super.init()
        locationManager.delegate = self
        requestGeolocation()
        //print(weather[0].daily[0].weather.description)
    }
    
    func requestGeolocation(){
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationState = locationManager.authorizationStatus
        
        if locationManager.authorizationStatus == CLAuthorizationStatus.authorizedAlways || locationManager.authorizationStatus == CLAuthorizationStatus.authorizedWhenInUse{
            //Have permission and start locating
            locationManager.startUpdatingLocation()
        }
        else if locationManager.authorizationStatus == .denied{
            //Don't have permission
        }
    }
    
    func updateLocation(){
        if authorizationState == .authorizedAlways || authorizationState == .authorizedWhenInUse{
            
            requestGeolocation()
        }
        else{
            requestGeolocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.first
        
        if userLocation != nil{
            locationManager.stopUpdatingLocation()
            
            let geoCoder = CLGeocoder()
            
            geoCoder.reverseGeocodeLocation(userLocation!) { placemarks, error in
                
                if error == nil && placemarks != nil{
                    
                    self.placemark = placemarks?.first
                }
                
            }
            
            getWeather(userLocation!)
        }
    }
    
    func getWeather(_ location: CLLocation) {
        if let urlImp = URL(string: Constants.apiUrl + "lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&exclude=minutely,alerts&units=imperial&appid=7ef1538a1ddb3108adab0227bde60492"){
            
            URLSession.shared.dataTask(with: urlImp) { data, response, error in

                do {
                    if error == nil && data != nil{
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(WeatherNOW.self, from: data!)
                        DispatchQueue.main.async {
                            self.weatherImp = result
                            if self.weatherImp != nil{
                                for hour in self.weatherImp!.hourly{
                                    
                                    var time = self.stringFromDateHour(NSDate(timeIntervalSince1970: TimeInterval(hour.dt)) as Date)
                                    
                                    let intTime = Int(time)!
                                    
                                    if intTime == 0{
                                        time = "12 AM"
                                    }
                                    else if intTime < 10{
                                        time = "\(intTime) AM"
                                    }
                                    else if intTime < 12{
                                        time += " AM"
                                    }
                                    else if intTime == 12{
                                        time += " PM"
                                    }
                                    else{
                                        time = "\((intTime - 12)) PM"
                                    }
                                    
                                    self.hourlyTime.append(time)
                                }
                            }
                            
                        }
                    }
                }
                catch{
                    print(error)

                    return
                }
            }.resume()
        }
        
        if let urlMet = URL(string: Constants.apiUrl + "lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&exclude=minutely,alerts&units=metric&appid=7ef1538a1ddb3108adab0227bde60492"){
            
            URLSession.shared.dataTask(with: urlMet) { data, response, error in
                
                do {
                    if error == nil && data != nil{
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(WeatherNOW.self, from: data!)
                        DispatchQueue.main.async {
                            self.weatherMet = result
                        }
                    }
                }
                catch{
                    print(error)

                    return
                }
                
            }.resume()
            
            
        }
    }
    
    func stringFromDateHour(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        //formatter.dateFormat = "HH:mm Mdd MMM" //yyyy
        return formatter.string(from: date)
    }
    
    static func stringFromDateDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    static func stringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd"
        return formatter.string(from: date)
    }
    
    static func stringFromDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        let minutes = formatter.string(from: date)
        formatter.dateFormat = "HH"
        let hour = formatter.string(from: date)
        
        var time: String = ""
        let intTime = Int(hour)!
        
        if intTime == 0{
            time = "12:\(minutes) AM"
        }
        else if intTime < 10{
            time = "\(intTime):\(minutes) AM"
        }
        else if intTime < 12{
            time = "\(intTime):\(minutes) AM"
        }
        else if intTime == 12{
            time = "12:\(minutes) PM"
        }
        else{
            time = "\((intTime - 12)):\(minutes) PM"
        }
        return time
    }
    
    func getGradient() -> Gradient{
        var grad: Gradient
        switch weatherImp!.current.weather[0].icon{
        case "01d":
            grad = Gradient(colors: [Color(red: 118.0/255.0, green: 239.0/255.0, blue: 1), Color(red: 0, green: 178.0/255.0, blue: 1)])
            break
        case "01n":
            grad = Gradient(colors: [Color(red: 31/255.0, green: 39/255.0, blue: 98/255.0), Color(red: 17/255.0, green: 21/255.0, blue: 51/255.0)])
            break
        case "02d":
            grad = Gradient(colors: [Color(red: 104/255.0, green: 214/255.0, blue: 230/255.0), Color(red: 0, green: 155/255.0, blue: 222/255.0)])
            break
        case "02n":
            grad = Gradient(colors: [Color(red: 31/255.0, green: 39/255.0, blue: 98/255.0), Color(red: 17/255.0, green: 21/255.0, blue: 51/255.0)])
            break
        case "03d":
            grad = Gradient(colors: [Color(red: 92/255.0, green: 193/255.0, blue: 208/255.0), Color(red: 0, green: 134/255.0, blue: 191/255.0)])
            break
        case "03n":
            grad = Gradient(colors: [Color(red: 31/255.0, green: 39/255.0, blue: 98/255.0), Color(red: 17/255.0, green: 21/255.0, blue: 51/255.0)])
            break
        case "04d":
            grad = Gradient(colors: [Color(red: 82/255.0, green: 176/255.0, blue: 190/255.0), Color(red: 0, green: 112/255.0, blue: 160/255.0)])
            break
        case "04n":
            grad = Gradient(colors: [Color(red: 31/255.0, green: 39/255.0, blue: 98/255.0), Color(red: 17/255.0, green: 21/255.0, blue: 51/255.0)])
            break
        case "09d":
            grad = Gradient(colors: [Color(red: 82/255.0, green: 176/255.0, blue: 190/255.0), Color(red: 86/255.0, green: 112/255.0, blue: 123/255.0)])
            break
        case "09n":
            grad = Gradient(colors: [Color(red: 82/255.0, green: 176/255.0, blue: 190/255.0), Color(red: 86/255.0, green: 112/255.0, blue: 123/255.0)])
            break
        case "10d":
            grad = Gradient(colors: [Color(red: 83/255.0, green: 158/255.0, blue: 190/255.0), Color(red: 53/255.0, green: 82/255.0, blue: 95/255.0)])
            break
        case "10n":
            grad = Gradient(colors: [Color(red: 83/255.0, green: 158/255.0, blue: 190/255.0), Color(red: 53/255.0, green: 82/255.0, blue: 95/255.0)])
            break
        case "11d":
            grad = Gradient(colors: [Color(red: 49/255.0, green: 34/255.0, blue: 141/255.0), Color(red: 7/255.0, green: 5/255.0, blue: 79/255.0)])
            break
        case "11n":
            grad = Gradient(colors: [Color(red: 49/255.0, green: 34/255.0, blue: 141/255.0), Color(red: 7/255.0, green: 5/255.0, blue: 79/255.0)])
            break
        case "13d":
            grad = Gradient(colors: [Color(red: 189/255.0, green: 239/255.0, blue: 244/255.0), Color(red: 137/255.0, green: 217/255.0, blue: 218/255.0)])
            break
        case "13n":
            grad = Gradient(colors: [Color(red: 111/255.0, green: 150/255.0, blue: 155/255.0), Color(red: 57/255.0, green: 102/255.0, blue: 103/255.0)])
            break
        case "50d":
            grad = Gradient(colors: [Color(red: 178/255.0, green: 178/255.0, blue: 178/255.0), Color(red: 99/255.0, green: 99/255.0, blue: 99/255.0)])
            break
        case "50n":
            grad = Gradient(colors: [Color(red: 178/255.0, green: 178/255.0, blue: 178/255.0), Color(red: 99/255.0, green: 99/255.0, blue: 99/255.0)])
            break
        default:
            grad = Gradient(colors: [Color(red: 118.0/255.0, green: 239.0/255.0, blue: 1), Color(red: 0, green: 178.0/255.0, blue: 1)])
        }
        return grad
    }
    
    static func getGradient(day: Daily) -> Gradient{
        var grad: Gradient
        switch day.weather[0].icon{
        case "01d":
            grad = Gradient(colors: [Color(red: 118.0/255.0, green: 239.0/255.0, blue: 1), Color(red: 0, green: 178.0/255.0, blue: 1)])
            break
        case "01n":
            grad = Gradient(colors: [Color(red: 31/255.0, green: 39/255.0, blue: 98/255.0), Color(red: 17/255.0, green: 21/255.0, blue: 51/255.0)])
            break
        case "02d":
            grad = Gradient(colors: [Color(red: 104/255.0, green: 214/255.0, blue: 230/255.0), Color(red: 0, green: 155/255.0, blue: 222/255.0)])
            break
        case "02n":
            grad = Gradient(colors: [Color(red: 31/255.0, green: 39/255.0, blue: 98/255.0), Color(red: 17/255.0, green: 21/255.0, blue: 51/255.0)])
            break
        case "03d":
            grad = Gradient(colors: [Color(red: 92/255.0, green: 193/255.0, blue: 208/255.0), Color(red: 0, green: 134/255.0, blue: 191/255.0)])
            break
        case "03n":
            grad = Gradient(colors: [Color(red: 31/255.0, green: 39/255.0, blue: 98/255.0), Color(red: 17/255.0, green: 21/255.0, blue: 51/255.0)])
            break
        case "04d":
            grad = Gradient(colors: [Color(red: 82/255.0, green: 176/255.0, blue: 190/255.0), Color(red: 0, green: 112/255.0, blue: 160/255.0)])
            break
        case "04n":
            grad = Gradient(colors: [Color(red: 31/255.0, green: 39/255.0, blue: 98/255.0), Color(red: 17/255.0, green: 21/255.0, blue: 51/255.0)])
            break
        case "09d":
            grad = Gradient(colors: [Color(red: 82/255.0, green: 176/255.0, blue: 190/255.0), Color(red: 86/255.0, green: 112/255.0, blue: 123/255.0)])
            break
        case "09n":
            grad = Gradient(colors: [Color(red: 82/255.0, green: 176/255.0, blue: 190/255.0), Color(red: 86/255.0, green: 112/255.0, blue: 123/255.0)])
            break
        case "10d":
            grad = Gradient(colors: [Color(red: 83/255.0, green: 158/255.0, blue: 190/255.0), Color(red: 53/255.0, green: 82/255.0, blue: 95/255.0)])
            break
        case "10n":
            grad = Gradient(colors: [Color(red: 83/255.0, green: 158/255.0, blue: 190/255.0), Color(red: 53/255.0, green: 82/255.0, blue: 95/255.0)])
            break
        case "11d":
            grad = Gradient(colors: [Color(red: 49/255.0, green: 34/255.0, blue: 141/255.0), Color(red: 7/255.0, green: 5/255.0, blue: 79/255.0)])
            break
        case "11n":
            grad = Gradient(colors: [Color(red: 49/255.0, green: 34/255.0, blue: 141/255.0), Color(red: 7/255.0, green: 5/255.0, blue: 79/255.0)])
            break
        case "13d":
            grad = Gradient(colors: [Color(red: 189/255.0, green: 239/255.0, blue: 244/255.0), Color(red: 137/255.0, green: 217/255.0, blue: 218/255.0)])
            break
        case "13n":
            grad = Gradient(colors: [Color(red: 111/255.0, green: 150/255.0, blue: 155/255.0), Color(red: 57/255.0, green: 102/255.0, blue: 103/255.0)])
            break
        case "50d":
            grad = Gradient(colors: [Color(red: 178/255.0, green: 178/255.0, blue: 178/255.0), Color(red: 99/255.0, green: 99/255.0, blue: 99/255.0)])
            break
        case "50n":
            grad = Gradient(colors: [Color(red: 178/255.0, green: 178/255.0, blue: 178/255.0), Color(red: 99/255.0, green: 99/255.0, blue: 99/255.0)])
            break
        default:
            grad = Gradient(colors: [Color(red: 118.0/255.0, green: 239.0/255.0, blue: 1), Color(red: 0, green: 178.0/255.0, blue: 1)])
        }
        return grad
    }
}
