//
//  ContentView.swift
//  Haberler
//
//  Created by Merve Akçakaya on 6.07.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HaberView()
                .tabItem { Label("Haberler", systemImage: "newspaper") }

            AramaView()
                .tabItem { Label("Ara", systemImage: "magnifyingglass") }
        }
    }
}

#Preview {
    ContentView()
}
