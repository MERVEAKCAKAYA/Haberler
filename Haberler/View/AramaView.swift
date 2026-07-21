//
//  AramaView.swift
//  Haberler
//
//  Created by Merve Akçakaya on 21.07.2026.
//

import SwiftUI

struct AramaView: View {
    @StateObject private var viewModel = AramaViewModel()

    var body: some View {
        NavigationStack {
            List(viewModel.sonuclar) { haber in
                NavigationLink(value: haber) {
                    HStack {
                        CachedImage(urlString: haber.imageURL)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        Text(haber.title).font(.headline)
                    }
                }
            }
            .navigationTitle("Ara")
            .navigationDestination(for: HaberYaniti.self) { haber in
                HaberDetayView(haber: haber)
            }
            .overlay {
                if viewModel.araniyor {
                    ProgressView()
                } else if viewModel.sonuclar.isEmpty && !viewModel.aramaMetni.isEmpty {
                    ContentUnavailableView("Sonuç yok", systemImage: "magnifyingglass")
                }
            }
            .searchable(text: $viewModel.aramaMetni, prompt: "Haber ara")
        }
    }
}

#Preview {
    AramaView()
}
