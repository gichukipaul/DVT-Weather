//
//  ForecastTableView.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI

struct ForecastTableView: View {
    @ObservedObject var viewModel: MainWeatherViewModel
    
    var body: some View {
        List(viewModel.forecasts ?? [], id: \.self) { forecast in
            ForecastRow(forecast: forecast)
        }
        .listStyle(.plain)
    }
}

#Preview {
    ForecastTableView(viewModel: MainWeatherViewModel())
}
