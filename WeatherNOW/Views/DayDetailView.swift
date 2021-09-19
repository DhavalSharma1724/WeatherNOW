//
//  DayDetailView.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/17/21.
//

import SwiftUI

struct DayDetailView: View {
    
    @EnvironmentObject var weather: WeatherModel
    var day: Daily
    var gradient: LinearGradient
    
    init(day: Daily){
        self.day = day
        gradient = LinearGradient(gradient: WeatherModel.getGradient(day: day), startPoint: .topTrailing, endPoint: .bottomLeading)
    }
    var body: some View {
        ZStack{
            gradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: -20){
                        Text(weather.placemark?.locality ?? "Unknown")
                            .font(Font.custom("Avenir Heavy", size: 48))
                            .padding(.top, 30)
                        
                        Text(String(Int(day.feels_like.day))+"˚")
                            .font(Font.custom("Avenir Heavy", size: 108))
                        
                        Text("\(day.weather[0].main) – \(WeatherModel.stringFromDateDay(NSDate(timeIntervalSince1970: TimeInterval(day.dt)) as Date))")
                            .font(Font.custom("Avenir Heavy", size: 18))
                            .opacity(0.8)
                    }
                    
                    Spacer()
                }
                
                //Divider
                Rectangle()
                    .cornerRadius(20)
                    .frame(height: 1)
                    .foregroundColor(.white)
                    .opacity(0.5)
                
                //Background
                HStack{
                    ZStack{
                        Rectangle()
                        .foregroundColor(.black)
                        .opacity(0.05)
                        .cornerRadius(10)
                        
                        VStack{
                            Rectangle()
                                .foregroundColor(.red)
                                .aspectRatio(1.0, contentMode: .fit)
                            Text(WeatherModel.stringFromDateTime(NSDate(timeIntervalSince1970: TimeInterval(day.sunrise)) as Date))
                                .font(Font.custom("Avenir Heavy", size: 18))
                                .padding(.bottom, 0)
                            
                            Rectangle()
                                .foregroundColor(.red)
                                .aspectRatio(1.0, contentMode: .fit)
                            
                            Text(WeatherModel.stringFromDateTime(NSDate(timeIntervalSince1970: TimeInterval(day.sunset)) as Date))
                                .font(Font.custom("Avenir Heavy", size: 18))
                                .padding(.bottom, 0)
                        }
                        .padding(.vertical)
                    }
                    
                    ZStack{
                        Rectangle()
                        .foregroundColor(.black)
                        .opacity(0.05)
                        .cornerRadius(8)
                        
                        VStack{
                            Rectangle()
                                .foregroundColor(.red)
                                .aspectRatio(1.0, contentMode: .fit)
                            Text(WeatherModel.stringFromDateTime(NSDate(timeIntervalSince1970: TimeInterval(day.moonrise)) as Date))
                                .font(Font.custom("Avenir Heavy", size: 18))
                                .padding(.bottom, 0)
                                                        
                            Rectangle()
                                .foregroundColor(.red)
                                .aspectRatio(1.0, contentMode: .fit)
                            
                            Text(WeatherModel.stringFromDateTime(NSDate(timeIntervalSince1970: TimeInterval(day.moonset)) as Date))
                                .font(Font.custom("Avenir Heavy", size: 18))
                                .padding(.bottom, 0)
                        }
                        .padding(.vertical)
                    }
                }
                .frame(height: 350)
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
                                DayCard(topic: topic, day: day, weather: weather)
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 6)
                    }
                }
            }
            .padding(.horizontal, 25)
        }
        .foregroundColor(.white)
    }
}
