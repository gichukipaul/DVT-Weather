//
//  TemperatureStackView.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI

struct TemperatureStackView: View {
    @ObservedObject var viewModel: MainWeatherViewModel
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Text("\(Int(viewModel.currentWeather?.main?.tempMin ?? 00))°")
                    .font(.title)
                Text("Min  ")
                    .font(.subheadline)
            }
            
            Spacer()
            
            VStack {
                Text("\(Int(viewModel.currentWeather?.main?.temp ?? 00))°")
                    .font(.title)
                Text("Current")
                    .font(.subheadline)
            }
            
            Spacer()
            
            VStack {
                Text("\(Int(viewModel.currentWeather?.main?.tempMax ?? 00))°")
                    .font(.title)
                Text("Max")
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    TemperatureStackView(viewModel: MainWeatherViewModel())
}
