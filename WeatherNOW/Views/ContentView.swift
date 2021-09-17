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
            ZStack{
                //Background
                LinearGradient(
                    gradient: Gradient(colors: [Color(red: 118.0/255.0, green: 239.0/255.0, blue: 1), Color(red: 0, green: 178.0/255.0, blue: 1)]),
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
                        }

                        
                        Spacer()
                        
                        Button(action: {
                            selectedTab = 0
                        }, label: {
                            Image(systemName: "star.fill")
                                .foregroundColor(selectedTab == 0 ? .blue : .white)
                        })
                        Spacer()
                        Button(action: {
                            selectedTab = 1
                        }, label: {
                            Image(systemName: "pencil")
                                .foregroundColor(selectedTab == 1 ? .blue : .white)
                        })
                        Spacer()
                    }
                    .padding(.top)
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
