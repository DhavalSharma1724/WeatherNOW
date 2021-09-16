//
//  CardDetailView.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/16/21.
//

import SwiftUI

struct CardDetailView: View {
    
    var topic: String
    var gradient: Gradient
    var value: Double = 0
    var unit: String = ""
    var description: String = ""
    var rectangleHeight = 1
    
    init(topic: String, gradient: Gradient, value: Double, unit: String){
        self.topic = topic
        self.gradient = gradient
        self.value = value
        self.unit = unit
        
        switch topic{
        case "Humidity":
            self.description = ""
            rectangleHeight = 241
            break
        case "Dew Point":
            self.description = ""
            break
        case "UV Index":
            self.description = ""
            break
        case "Wind Speed":
            self.description = ""
            break
        case "Clouds":
            self.description = ""
            break
        default:
            break
        }
        
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: gradient, startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
            
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
                        .padding(.bottom, 18)
                }
                .padding(.bottom, -4)
                ZStack{
                    //Background
                    Rectangle()
                        .foregroundColor(.black)
                        .opacity(0.05)
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
                        
                        Text("Humidity measures the amount of water vapor in the air. In other words, if the humidity is at 100%, the air cannot hold any more water vapor. This means sweat cannot evaporate off your body, making it feel hotter than it actually is. If the humidity is low, sweat easily evaporates, making you feel colder.")
                            .font(Font.custom("Avenir", size: 16))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, 25)
                .frame(height: CGFloat(rectangleHeight))
                
                Spacer()
            }
            
            
        }
        .foregroundColor(.white)
    }
}

struct CardDetailView_Preview: PreviewProvider {
    static var previews: some View {
        CardDetailView(topic: "Humidity", gradient: Gradient(colors: [.gray, .black]), value: 91.0, unit: "%")
    }
}
