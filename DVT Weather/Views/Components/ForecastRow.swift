//
//  ForecastRow.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI

struct ForecastRow: View {
    var forecast: ForecastInfo
    
    var body: some View {
        HStack {
            Text(forecast.dayOfWeek)
            Spacer()
            Text("\(forecast.temp)")
        }
        .padding()
    }
}

#Preview {
    ForecastRow(forecast: ForecastInfo(forecastDate: "MON", dayOfWeek: "2", time: "1223", weather: "rain", temp: "23", weatherIcon: UIImage(systemName: "globe")!))
}
