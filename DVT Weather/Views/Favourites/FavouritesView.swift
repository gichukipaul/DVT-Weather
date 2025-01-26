//
//  FavouritesView.swift
//  DVT Weather
//
//  Created by GICHUKI on 26/01/2025.
//

import SwiftUI

struct FavouritesView: View {
    var body: some View {
        VStack {
            Text("Favourites Screen")
                .font(.title)
                .foregroundColor(Color(UIColor.systemBlue))
        }
        .navigationTitle("Favourites")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    FavouritesView()
}
