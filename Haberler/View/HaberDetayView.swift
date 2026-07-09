//
//  HaberDetayView.swift
//  Haberler
//
//  Created by Merve Akçakaya on 6.07.2026.
//

import SwiftUI

struct HaberDetayView: View {
    let haber: HaberYaniti
    var body: some View {
        Text(haber.title)
    }
}

#Preview {
    HaberDetayView(haber: HaberYaniti(id: 1234, title: "Haber1", url: "", authors: [], imageURL: "", publishedAt: Date.now))
}
