//
//  CardView.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/16/21.
//

import Foundation
import SwiftUI

struct Card: View{
    
    @EnvironmentObject var weather: WeatherNOW
    var topic: String
    var gradient: Gradient
    
    init(topic: String){
        self.topic = topic
        switch topic{
        case "Humidity":
            gradient = Gradient(colors: [.gray, .black])
            break
        case "Dew Point":
            gradient = Gradient(colors: [.white, .blue])
            break
        case "UV Index":
            gradient = Gradient(colors: [.orange, .red])
            break
        case "Wind Speed":
            gradient = Gradient(colors: [.white, .gray])
            break
        case "Clouds":
            gradient = Gradient(colors: [.gray, .white])
            break
        default:
            gradient = Gradient(colors: [.blue, .black])
        }
    }
    
    var body: some View{
        
        ZStack(alignment: .leading){
            Rectangle()
                .fill(LinearGradient(gradient: gradient, startPoint: .topTrailing, endPoint: .bottomLeading))
                .cornerRadius(10)
            
            Text(topic)
                .font(Font.custom("Avenir Heavy", size: 18))

        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    
}
