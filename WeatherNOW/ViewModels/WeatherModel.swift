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
    
    @Published var weather: WeatherNOW?
    @Published var placemark: CLPlacemark?
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    
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
        if let url = URL(string: Constants.apiUrl + "lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&exclude=minutely,alerts&units=imperial&appid=7ef1538a1ddb3108adab0227bde60492"){
            
            URLSession.shared.dataTask(with: url) { data, response, error in

                do {
                    if error == nil && data != nil{
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(WeatherNOW.self, from: data!)
                        DispatchQueue.main.async {
                            self.weather = result
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
    
    
}
