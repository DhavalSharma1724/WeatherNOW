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
    @State var isShowing = false
    
    init(day: Daily, index: Int){
        self.day = day
        self.index = index
    }
    var body: some View {
        Button {
            isShowing = true
        } label: {
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
                HStack{
                    Image(day.weather[0].icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 72*1.1565762, height: 72)
                    
                    Text(day.pop != 0 ? "\(Int(day.pop*100))%" : "")
                        .font(Font.custom("Avenir Heavy", size: 20))
                        .foregroundColor(Color(red: 0, green: 230/255.0, blue: 1))
                }
                .frame(width: 150, alignment: .leading)
                
                
                Spacer()
                VStack(alignment: .trailing){
                    Text(String(Int(day.temp.max)))
                        .font(Font.custom("Avenir Heavy", size: 20))
                        .frame(width: 66, alignment: .trailing)
                    
                    
                    Text(String(Int(day.temp.min)))
                        .font(Font.custom("Avenir Heavy", size: 20))
                        .opacity(0.8)
                }

            }
            .padding(.bottom, -1)
        }
        .sheet(isPresented: $isShowing) {
            DayDetailView(day: day)
        }
    }
}
