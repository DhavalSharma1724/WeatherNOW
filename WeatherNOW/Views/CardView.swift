//
//  CardView.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/16/21.
//

import Foundation
import SwiftUI

struct Card: View{
    
    @State var weather: WeatherModel
    var topic: String
    var gradient: Gradient
    var value: Double = 0
    var unit: String = ""
    @State var isShowing = false
    
    init(topic: String, weather: WeatherModel){
        self.weather = weather
        self.topic = topic
        switch topic{
        case "Humidity":
            gradient = Gradient(colors: [Color(red: 160.0/255, green: 134.0/255, blue: 175.0/255), Color(red: 105.0/255, green: 85.0/255, blue: 115.0/255)])
            value = Double((self.weather.weatherImp!.current.humidity))
            unit = "%"
            break
        case "Dew Point":
            gradient = Gradient(colors: [Color(red: 0/255, green: 192.0/255, blue: 255/255), Color(red: 70.0/255, green: 67.0/255, blue: 195.0/255)])

            value = self.weather.imperial ? self.weather.weatherImp!.current.dew_point : self.weather.weatherMet!.current.dew_point
            unit = "˚"
            break
        case "UV Index":
            gradient = Gradient(colors: [Color(red: 209.0/255, green: 150.0/255, blue: 24.0/255), Color(red: 199.0/255, green: 37.0/255, blue: 0/255)])
            value = self.weather.weatherImp!.current.uvi
            break
        case "Wind Speed":
            gradient = Gradient(colors: [Color(red: 160.0/255, green: 103.0/255, blue: 157.0/255), Color(red: 206.0/255, green: 7.0/255, blue: 96.0/255)])
            value = self.weather.imperial ? self.weather.weatherImp!.current.wind_speed : self.weather.weatherMet!.current.wind_speed
            unit = self.weather.imperial ? " mph" : " m/s"
            break
        case "Clouds":
            gradient = Gradient(colors: [Color(red: 180.0/255, green: 243.0/255, blue: 255.0/255), Color(red: 64.0/255, green: 151.0/255, blue: 167.0/255)])
            value = Double((self.weather.weatherImp!.current.clouds))
            unit = "%"
            break
        default:
            gradient = Gradient(colors: [.blue, .black])
            value = 0.0
        }
    }
    
    var body: some View{
        Button(action: {
            isShowing = true
        }, label: {
            ZStack(alignment: .leading){
                Rectangle()
                    .fill(LinearGradient(gradient: gradient, startPoint: .topTrailing, endPoint: .bottomLeading))
                    .cornerRadius(8)
                VStack(alignment: .leading){
                    
                    Text(topic)
                        .font(Font.custom("Avenir Heavy", size: 14))
                        .padding(.top, 3)
                    Spacer()
                    HStack(alignment: .bottom, spacing: -4){
                        Text(topic == "Wind Speed" ? String(Int(value)) : String(Int(value)) + unit)
                            .font(Font.custom("Avenir Heavy", size: 42))
                        Text(topic == "Wind Speed" ? unit : "")
                            .font(Font.custom("Avenir Heavy", size: 20))
                            .padding(.bottom, 8)
                    }
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Text("→")
                            .font(Font.custom("Avenir Heavy", size: 14))
                            .opacity(1)
                    }

                    
                }
                .padding(15)

            }
        })
        .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $isShowing){
            
            CardDetailView(topic: topic, gradient: gradient, value: value, unit: unit, gradientBackground: weather.getGradient())
            
        }
        
    }
    
    
}
