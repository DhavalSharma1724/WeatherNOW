//
//  CurrentView.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/15/21.
//

import SwiftUI

struct CurrentView: View {
    
    @EnvironmentObject var weather: WeatherModel
    
    var body: some View {
        
        if weather.weatherImp != nil && weather.weatherMet != nil{
            VStack (alignment: .leading){
                
                //MARK: Top Section
                HStack{
                    VStack (alignment: .leading, spacing: -20){
                        //Place
                        Button {
                            print("HEO")
                            weather.requestGeolocation()
                        } label: {
                            Text(weather.placemark?.locality ?? "")
                                .font(Font.custom("Avenir Heavy", size: 48))
                                .padding(.top, 30)
                        }
                        
                        //Temperature
                        Text("\(Int(weather.imperial ? weather.weatherImp!.current.temp : weather.weatherMet!.current.temp))˚")
                            .font(Font.custom("Avenir Heavy", size: 108))
                        
                        //Descriptor
                        Text("\(weather.weatherImp!.current.weather[0].main) – Feels like: \(Int(weather.imperial ? weather.weatherImp!.current.feels_like : weather.weatherMet!.current.feels_like))˚")
                            .font(Font.custom("Avenir Heavy", size: 18))
                            .bold()
                    }
                }
                
                //Divider
                Rectangle()
                    .cornerRadius(20)
                    .frame(height: 1)
                    .foregroundColor(.white)
                    .opacity(0.5)
                
                //Hourly
                ZStack{
                    //Background
                    Rectangle()
                        .foregroundColor(.black)
                        .opacity(0.05)
                        .cornerRadius(10)
                    
                    //Scroll Content
                    ScrollView(showsIndicators: false){
                        VStack{
                            ForEach(1..<25){index in
                                
                                //Single Row
                                HStack{
                                    Text(weather.hourlyTime[index])
                                        .font(Font.custom("Avenir Heavy", size: 18))
                                    Spacer()
                                    Text(String(Int(weather.imperial ? weather.weatherImp!.hourly[index].feels_like :  weather.weatherMet!.hourly[index].feels_like))+"˚")
                                        .font(Font.custom("Avenir Heavy", size: 18))
                                }
                                .padding(.horizontal)
                                .padding(.vertical, -1)
                                
                                if index != 24 {
                                    //Divider
                                    Rectangle()
                                        .opacity(0.4)
                                        .cornerRadius(20)
                                        .frame(height: 1)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .frame(height: 286)
                .padding(.vertical)
                
                //Divider
                Rectangle()
                    .cornerRadius(20)
                    .frame(height: 1)
                    .foregroundColor(.white)
                    .opacity(0.5)
                
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            Card(topic: "Humidity")
                            Card(topic: "UV Index")
                            Card(topic: "Dew Point")
                            Card(topic: "Clouds")
                            Card(topic: "Wind Speed")
                        }
                        .padding(.top)
                        .padding(.bottom, 6)
                    }
                }                
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 25)
        }
        else{
            ProgressView()
        }
    }
}

struct CurrentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentView()
    }
}
