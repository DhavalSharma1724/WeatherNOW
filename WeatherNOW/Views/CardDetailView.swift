//
//  CardDetailView.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/16/21.
//

import SwiftUI

struct CardDetailView: View {
    
    @EnvironmentObject var weather: WeatherModel
    var topic: String
    var gradient: Gradient
    var value: Double = 0
    var unit: String = ""
    var description: String = ""
    var rectangleHeight = 1
    var UVdescription = "Low"
    var UVcolor: Color = Color(red: 1.0, green: 1.0, blue: 1.0)
    var gradientBackground: Gradient
    
    init(topic: String, gradient: Gradient, value: Double, unit: String, gradientBackground: Gradient){
        self.gradientBackground = gradientBackground
        self.topic = topic
        self.gradient = gradient
        self.value = value
        self.unit = unit
        
        switch topic{
        case "Humidity":
            self.description = "Humidity measures the amount of water vapor in the air. In other words, if the humidity is at 100%, the air can't hold any more water vapor. This means sweat can't evaporate, making it feel hotter than it actually is. If the humidity is low, sweat easily evaporates, making you feel colder."
            rectangleHeight = 261
            break
        case "Dew Point":
            self.description = "Dew point represents the temperature the air needs to be cooled to reach a humidity of 100%. In other words, if the air gets any colder, water would leave the atmosphere as fog or precipitation."
            rectangleHeight = 200
            break
        case "UV Index":
            self.description = "The UV index represents how much harmful UV radiation is reaching an area. The higher the index, the more harmful it is for your skin when exposed."
            rectangleHeight = 275
            if value < 3{
                UVdescription = "Minimal"
                UVcolor = .green
            }
            else if value < 5{
                UVdescription = "Low"
                UVcolor = .yellow
            }
            else if value < 7{
                UVdescription = "Moderate"
                UVcolor = .orange
            }
            else if value < 10{
                UVdescription = "High"
                UVcolor = .red
            }
            else{
                UVdescription = "Very High"
                UVcolor = .purple
            }
            break
        case "Wind Speed":
            self.description = "Wind speed measures how fast the air is moving. In this case, the wind speed displayed is averaged over a period of time."
            rectangleHeight = 175
            break
        case "Clouds":
            self.description = "Cloudiness measures what percentage of the sky is covered in clouds. A higher percentage means more of the sky will be covered in clouds."
            rectangleHeight = 175
            break
        default:
            break
        }
        
    }
    
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: gradientBackground, startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
            
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: gradient, startPoint: .topTrailing, endPoint: .bottomLeading))
                    .cornerRadius(15)
                
                VStack(alignment: .center) {
                    Text(topic)
                        .font(Font.custom("Avenir Heavy", size: 48))
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    HStack(alignment: .bottom, spacing: -4){
                        Text(topic == "Wind Speed" ? String(Int(value)) : String(Int(value)) + unit)
                            .font(Font.custom("Avenir Heavy", size: 126))
                        Text(topic == "Wind Speed" ? unit : "")
                            .font(Font.custom("Avenir Heavy", size: 60))
                            .padding(.bottom, 24)
                            .padding(.leading, 4)
                    }
                    .padding(.bottom, -4)
                    ZStack{
                        //Background
                        Rectangle()
                            .foregroundColor(.black)
                            .opacity(0.1)
                            .cornerRadius(10)
                        
                        VStack (alignment: .leading){
                            Text("What does this mean?")
                                .font(Font.custom("Avenir Heavy", size: 24))
                                .padding(.vertical, -5)
                                .padding(.top, 25)
                            
                            //Divider
                            Rectangle()
                                .opacity(0.8)
                                .cornerRadius(20)
                                .frame(width: 100, height: 3)
                                .foregroundColor(.white)
                            
                            Text(description)
                                .font(Font.custom("Avenir", size: 16))
                            
                            if topic == "UV Index"{
                                Text("Exposure Category: ")
                                    .font(Font.custom("Avenir Heavy", size: 24))
                                    .padding(.vertical, -5)
                                    .padding(.top, 5)
                                
                                //Divider
                                Rectangle()
                                    .opacity(0.8)
                                    .cornerRadius(20)
                                    .frame(width: 100, height: 3)
                                    .foregroundColor(.white)
                                
                                Text(UVdescription)
                                    .font(Font.custom("Avenir Heavy", size: 24))
                                    .foregroundColor(UVcolor)
                                    .padding(.top, -2)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal, 25)
                    .frame(height: CGFloat(rectangleHeight))
                    
                    Spacer()
                }
                
                
            }
            .frame(height: 320 + CGFloat(rectangleHeight))
            .padding(.horizontal, 25)
            .foregroundColor(.white)
        }
        
    }
}

