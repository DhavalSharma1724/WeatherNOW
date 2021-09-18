//
//  WeatherModel.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/13/21.
//

import Foundation
import CoreLocation

class WeatherModel: NSObject, CLLocationManagerDelegate, ObservableObject{
    var locationManager = CLLocationManager()
    
    @Published var weatherImp: WeatherNOW?
    @Published var weatherMet: WeatherNOW?
    @Published var placemark: CLPlacemark?
    @Published var imperial = true
    var hourlyTime = [String]()
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    var topics = ["Humidity", "UV Index", "Clouds", "Wind Speed", "Dew Point"]
    
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
}
