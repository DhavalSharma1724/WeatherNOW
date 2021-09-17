//
//  DayRowView.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/17/21.
//

import SwiftUI

struct DayRowView: View {
    var day: Daily
    var index: Int
    
    init(day: Daily, index: Int){
        self.day = day
        self.index = index
    }
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment: .leading){
                Text(index == 0 ? "Today" : WeatherModel.stringFromDateDay(NSDate(timeIntervalSince1970: TimeInterval(day.dt)) as Date))
                    .font(Font.custom("Avenir Heavy", size: 24))
                    .frame(width: 131, alignment: .leading)
                Text(WeatherModel.stringFromDate(NSDate(timeIntervalSince1970: TimeInterval(day.dt)) as Date))
                    .font(Font.custom("Avenir Heavy", size: 20))
                    .opacity(0.8)
            }
            .frame(width: 131)
            
            Spacer()
            
            Spacer()
            VStack(alignment: .trailing){
                Text(String(day.temp.max))
                    .font(Font.custom("Avenir Heavy", size: 20))
                    .frame(width: 66, alignment: .trailing)
                Text(String(day.temp.min))
                    .font(Font.custom("Avenir Heavy", size: 20))
                    .opacity(0.8)
            }

        }
        .padding(.bottom, -1)
    }
}
