//
//  CurrentView.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/15/21.
//

import SwiftUI

struct CurrentView: View {
    
    @EnvironmentObject var weather: WeatherModel
    var rainIcons = ["9d", "9n", "10d", "10n", "11d", "11n", "13d", "13n"]
    
    var body: some View {
        
        if weather.weatherImp != nil && weather.weatherMet != nil{
            VStack (alignment: .leading){
                
                //MARK: Top Section
                    VStack (alignment: .leading, spacing: -20){

                            Text(weather.placemark?.locality ?? "")
                                .font(Font.custom("Avenir Heavy", size: 48))
                                .padding(.top, 30)

                        HStack{
                            VStack(alignment: .leading, spacing: -20){
                                //Temperature
                                Text("\(Int(weather.imperial ? weather.weatherImp!.current.temp : weather.weatherMet!.current.temp))˚")
                                    .font(Font.custom("Avenir Heavy", size: 108))
                                
                                //Descriptor
                                Text("\(weather.weatherImp!.current.weather[0].main) – Feels like: \(Int(weather.imperial ? weather.weatherImp!.current.feels_like : weather.weatherMet!.current.feels_like))˚")
                                    .font(Font.custom("Avenir Heavy", size: 14))
                                    .opacity(0.8)
                                    .frame(width: 198, alignment: .leading)
                            }
                            
                            Image(weather.weatherImp!.current.weather[0].icon)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            
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
                        .opacity(0.1)
                        .cornerRadius(5)
                    
                    //Scroll Content
                    ScrollView(showsIndicators: false){
                        VStack{
                            ForEach(1..<25){index in
                                
                                //Single Row
                                HStack{
                                    Text(weather.hourlyTime[index])
                                        .font(Font.custom("Avenir Heavy", size: 18))
                                        .frame(width: 60, alignment: .leading)
                                    Spacer()
                                    HStack{
                                        Image(weather.weatherImp!.hourly[index].weather[0].icon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(height: 30)
                                        
                                        Text(weather.weatherImp!.hourly[index].pop != 0 && rainIcons.contains(weather.weatherImp!.hourly[index].weather[0].icon) ? "\(Int(weather.weatherImp!.hourly[index].pop*100))%" : "")
                                            .font(Font.custom("Avenir Heavy", size: 18))
                                            .foregroundColor(Color(red: 0, green: 230/255.0, blue: 1))
                                    }
                                    .frame(width: 100, alignment: .leading)
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
                            ForEach(weather.topics, id: \.self){topic in
                                Card(topic: topic, weather: weather)
                            }
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
