//
//  ContentView.swift
//  DVT Weather
//
//  Created by GICHUKI on 25/01/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var navigateToMainView = false
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    Spacer()
                    // Large Image
                    Image(systemName: "sun.dust.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.tint)
                        .padding(.bottom, 20)
                    
                    // Title Text
                    Text("WEATHER")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
                .onAppear {
                    locationManager.requestLocation()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    ContentView()
}
