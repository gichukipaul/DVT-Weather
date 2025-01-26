//
//  SearchLocationsView.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI

struct SearchLocationsView: View {
    var body: some View {
        VStack {
            Text("Search Location Screen")
                .font(.title)
                .foregroundColor(Color(UIColor.systemBlue))
        }
        .navigationTitle("Search Locations")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchLocationsView()
}
