//
//  WeatherModel.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/13/21.
//

import Foundation

class WeatherModel: NSObject, ObservableObject{
    
    @Published var weather = Weather()
    
    override init(){
        super.init()
        getWeather()
    }
    //temperature, temperatureApparent, humidity, windSpeed, precipitationIntesity, precipitationProbability, precipitationType, uvIndex, weatherCode
    //'https://api.tomorrow.io/v4/timelines?location=-73.98529171943665,40.75872069597532&fields=temperature&timesteps=1h&units=metric&apikey=GAsGsHhJ2FuEe5TsN2MPWB4QAsMurJ8Z'
    func getWeather(){

        let urlPath = "https://api.tomorrow.io/v4/timelines?location=-73.98529171943665,40.75872069597532&fields=temperature,temperatureApparent,,humidity,windSpeed,precipitationIntensity,precipitationProbability,precipitationType,uvIndex,weatherCode&timesteps=1h&units=metric&apikey=GAsGsHhJ2FuEe5TsN2MPWB4QAsMurJ8Z"
        if let url = URL(string: urlPath){

            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            
            let dataTast = session.dataTask(with: request) { data, response, error in

                guard error == nil else{
                    return
                }
                
                let decoder = JSONDecoder()

                do{
                    let result = try decoder.decode(Weather.self, from: data!)
                    self.weather = result
                    print(data!)

                }
                catch{
                    print(error)

                    return
                }
            }.resume()
        }
    }
    
    
}
