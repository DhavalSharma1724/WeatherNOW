//
//  ContentView.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/10/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var weather: WeatherModel
    @State var selectedTab = 0
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                TabView(selection: $selectedTab){
                    ForEach(0..<4, id: \.self){ index in
                        ZStack {
                            Rectangle()
                                .foregroundColor(selectedTab == 0 ? .green : .red)
                                .padding()
                            if weather.weather != nil{
                                Text(String(weather.placemark?.locality ?? ""))
                            }
                            else{
                                ProgressView()
                            }
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                //MARK: View Bar at bottom
                
                HStack{
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 0
                    }, label: {
                        Image(systemName: "star.fill")
                            .foregroundColor(selectedTab == 0 ? .blue : .black)
                    })
                    Spacer()
                    Button(action: {
                        selectedTab = 1
                    }, label: {
                        Image(systemName: "pencil")
                            .foregroundColor(selectedTab == 1 ? .blue : .black)
                    })
                    Spacer()
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
