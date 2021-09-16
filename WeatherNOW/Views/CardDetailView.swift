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
    
    init(topic: String, gradient: Gradient, value: Double, unit: String){
        self.topic = topic
        self.gradient = gradient
        self.value = value
        self.unit = unit
        
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: gradient, startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text(topic)
                    .font(Font.custom("Avenir Heavy", size: 48))
                    .foregroundColor(.white)
                
                HStack(alignment: .bottom, spacing: -4){
                    Text(topic == "Wind Speed" ? String(Int(value)) : String(Int(value)) + unit)
                        .font(Font.custom("Avenir Heavy", size: 126))
                    Text(topic == "Wind Speed" ? unit : "")
                        .font(Font.custom("Avenir Heavy", size: 60))
                        .padding(.bottom, 18)
                }
                
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
