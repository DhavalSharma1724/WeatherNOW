//
//  DailyView.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/17/21.
//

import SwiftUI

struct DailyView: View {
    
    @EnvironmentObject var weather: WeatherModel
    
    var body: some View {
        if weather.weatherImp != nil && weather.weatherMet != nil{
            
            VStack (alignment: .leading, spacing: 0){
                Text(weather.placemark?.locality ?? "")
                    .font(Font.custom("Avenir Heavy", size: 48))
                    .padding(.top, 30)
                
                //Divider
                Rectangle()
                    .cornerRadius(20)
                    .frame(height: 3)
                    .foregroundColor(.white)
                    .opacity(0.8)
                
                ScrollView(showsIndicators: false){
                    ForEach(1..<weather.weatherMet!.daily.count, id: \.self){index in
                        DayRowView(day: weather.imperial ? weather.weatherImp!.daily[index] : weather.weatherMet!.daily[index], index: index)
                        
                        if index != weather.weatherImp!.daily.count - 1 {
                            //Divider
                            Rectangle()
                                .opacity(0.6)
                                .cornerRadius(20)
                                .frame(height: 1)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top)
                
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
