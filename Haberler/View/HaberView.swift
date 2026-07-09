//
//  HaberView.swift
//  Haberler
//
//  Created by Merve Akçakaya on 6.07.2026.
//

import SwiftUI

struct HaberView: View {
    @State private var viewModel = HaberViewModel()
    var body: some View {
        NavigationStack {
            switch viewModel.durum {
            case .yukleniyor:
                ProgressView("Yükleniyor…")
            case .basarili(let haberler):
                List(haberler) { haber in
                    NavigationLink(value: haber) {
                       HStack {
                           AsyncImage(url: URL(string: haber.imageURL)) { image in
                               image.resizable().scaledToFill()
                           } placeholder: {
                               ProgressView()
                           }
                           .frame(width: 60, height: 60)
                           .clipShape(RoundedRectangle(cornerRadius: 8))

                           Text(haber.title).font(.headline)
                       }
                    }
                }
                .navigationTitle("Haberler")
                .navigationDestination(for: HaberYaniti.self){ haber in
                    HaberDetayView(haber: haber)
                }
                
            case .hata(let hata):
                Text("Hata: \(hata)")
            }
        }
        .task { await viewModel.loadData() }
    }
    
}

#Preview {
    HaberView()
}
