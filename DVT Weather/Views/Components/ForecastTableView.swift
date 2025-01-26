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
        List(viewModel.forecasts?.sorted(by: { $0.forecastDate < $1.forecastDate }) ?? [], id: \.self) { forecast in
            ForecastRow(forecast: forecast, backgroundColor: viewModel.backgroundColor)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    ForecastTableView(viewModel: MainWeatherViewModel())
}
