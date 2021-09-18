//
//  DayCard.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/18/21.
//

import SwiftUI

struct DayCard: View{
    
    @State var day: Daily
    @State var weather: WeatherModel
    var topic: String
    var gradient: Gradient
    var value: Double = 0
    var unit: String = ""
    @State var isShowing = false
    
    init(topic: String, day: Daily, weather: WeatherModel){
        self.day = day
        self.topic = topic
        self.weather = weather
        switch topic{
        case "Humidity":
            gradient = Gradient(colors: [.gray, .black])
            value = Double((self.day.humidity))
            unit = "%"
            break
        case "Dew Point":
            gradient = Gradient(colors: [.white, .blue])
            value = self.day.dew_point
            unit = "˚"
            break
        case "UV Index":
            gradient = Gradient(colors: [.orange, .red])
            value = self.day.uvi
            break
        case "Wind Speed":
            gradient = Gradient(colors: [.white, .gray])
            value = self.day.wind_speed
            unit = self.weather.imperial ? " mph" : " m/s"
            break
        case "Clouds":
            gradient = Gradient(colors: [.gray, .white])
            value = Double((self.day.clouds))
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
                    .cornerRadius(10)
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
            .aspectRatio(1, contentMode: .fit)
        })
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $isShowing){
            
            CardDetailView(topic: topic, gradient: gradient, value: value, unit: unit)
            
        }
        
    }
    
    
}
