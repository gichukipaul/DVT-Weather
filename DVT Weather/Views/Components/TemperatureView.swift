//
//  TemperatureView.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI

struct TemperatureView: View {
    @ObservedObject var viewModel: MainWeatherViewModel
    
    var body: some View {
        VStack {
            if let weather = viewModel.currentWeather {
                Text("\(Int(weather.main?.temp ?? 00))°")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(Color(UIColor.systemBackground))
                
                Text(weather.weather?.first?.description.capitalized ?? "Sunny")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color(UIColor.systemBackground))
            } else {
                Text("No Data at the Moment")
            }
        }
    }
}

#Preview {
    TemperatureView(viewModel: MainWeatherViewModel())
}
