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
        
        if weather.locationManager.authorizationStatus == .denied{
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 118.0/255.0, green: 239.0/255.0, blue: 1), Color(red: 0, green: 178.0/255.0, blue: 1)]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading)
                    .ignoresSafeArea()
                VStack(alignment: .center){
                    Text("Oops!")
                        .font(Font.custom("Avenir Heavy", size: 108))
                    Text("Please go into your settings to let WeatherNOW access your location.")
                        .font(Font.custom("Avenir Heavy", size: 20))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .opacity(0.8)
                }
                .padding(0)
                .foregroundColor(.white)
            }
            
        }
        else{
            GeometryReader { geo in
                if weather.weatherImp != nil{
                    ZStack{
                        //Background
                        LinearGradient(
                            gradient: weather.getGradient(),
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading)
                            .ignoresSafeArea()
                        
                        //Top part and Bottom Tab
                        
                        VStack {
                            //MARK: Top Part
                            TabView(selection: $selectedTab){
                                ForEach(0..<2, id: \.self){ index in
                                    if index == 0{
                                        CurrentView()
                                    }
                                    else{
                                        DailyView()
                                    }
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            
                            //MARK: View Bar at bottom
                            
                            Rectangle()
                                .cornerRadius(20)
                                .frame(height: 1)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            HStack{
                                Spacer()
                                
                                Button {
                                    weather.imperial.toggle()
                                } label: {
                                    Text(weather.imperial ? "˚F" : "˚C")
                                        .foregroundColor(.white)
                                        .font(Font.custom("Avenir Heavy", size: 18))
                                        .bold()
                                        .frame(width: 20, alignment: .center)
                                }

                                
                                Spacer()
                                
                                Button(action: {
                                    selectedTab = 0
                                }, label: {
                                    Image(selectedTab == 0 ? "dayOrange" : "day")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                })
                                Spacer()
                                Button(action: {
                                    selectedTab = 1
                                }, label: {
                                    Image(selectedTab == 1 ? "weekOrange" : "week")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                })
                                Spacer()
                            }
                            .padding(.top)
                        }
                    }
                }
                else{
                    ZStack{
                        
                        LinearGradient(gradient: Gradient(colors: [Color(red: 118.0/255.0, green: 239.0/255.0, blue: 1), Color(red: 0, green: 178.0/255.0, blue: 1)]), startPoint: .topTrailing, endPoint: .bottomLeading)
                            .ignoresSafeArea()
                        
                        ProgressView()
                    }
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
