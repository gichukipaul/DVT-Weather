//
//  ForecastRow.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI

struct ForecastRow: View {
    var forecast: ForecastInfo
    var backgroundColor: Color
    
    var body: some View {
        HStack {
            // First Text View
            Text(forecast.dayOfWeek)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Icon in the Center
            Image(uiImage: forecast.weatherIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(.blue)
            
            // Second Text View
            Text("\(forecast.temp)")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(backgroundColor)
    }
}

#Preview {
    ForecastRow(forecast: ForecastInfo(forecastDate: "MON", dayOfWeek: "2", time: "1223", weather: "rain", temp: "23", weatherIcon: UIImage(systemName: "globe")!), backgroundColor: Color(UIColor.systemBackground))
}
