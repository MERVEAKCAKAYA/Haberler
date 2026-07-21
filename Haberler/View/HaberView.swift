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
            Group {
                switch viewModel.durum {
                case .yukleniyor:
                    ProgressView("Yükleniyor…")
                case .basarili(let haberler):
                    List {
                        ForEach(haberler) { haber in
                            NavigationLink(value: haber) {
                                HStack {
                                    CachedImage(urlString: haber.imageURL)
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))

                                    Text(haber.title).font(.headline)
                                }
                            }
                            .onAppear {
                                if haber == haberler.last {
                                    Task { await viewModel.loadMore() }
                                }
                            }
                        }

                        if viewModel.isLoadingMore {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                case .hata(let hata):
                    Text("Hata: \(hata)")
                }
            }
            .navigationTitle("Haberler")
            .navigationDestination(for: HaberYaniti.self) { haber in
                HaberDetayView(haber: haber)
            }
        }
        .task { await viewModel.loadData() }
    }
    
}

#Preview {
    HaberView()
}
