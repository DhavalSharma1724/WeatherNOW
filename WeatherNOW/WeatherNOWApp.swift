//
//  WeatherNOWApp.swift
//  WeatherNOW
//
//  Created by Dhaval Sharma on 9/10/21.
//

import SwiftUI

@main
struct WeatherNOWApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(WeatherModel())
        }
    }
}
