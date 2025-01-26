//
//  HeaderView.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: MainWeatherViewModel
    
    var body: some View {
        HStack {
            ZStack {
                Image(viewModel.backgroundImage)
                    .resizable()
                    .scaledToFill()
                
                // Temperature View centered on the background
                TemperatureView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    HeaderView(viewModel: MainWeatherViewModel())
}
