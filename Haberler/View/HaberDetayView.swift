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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Color.clear
                    .frame(height: 220)
                    .overlay {
                        AsyncImage(url: URL(string: haber.imageURL)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .clipped()

                Text(haber.title)
                    .font(.title)
                    .fontWeight(.bold)

                HStack {
                    Image(systemName: "person")
                    Text(haber.authors.map(\.name).joined(separator: ", "))
                    Image(systemName: "clock")
                    Text(haber.publishedAt.formatted(date: .abbreviated, time: .omitted))
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                Divider()

                Text(haber.summary)
                    .font(.body)
                    

                if let url = URL(string: haber.url) {
                    Link(destination: url) {
                        HStack {
                            Text("Habere Git")
                            Image(systemName: "arrow.up.right")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Haber")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HaberDetayView(
            haber: HaberYaniti(
                id: 1234,
                title: "NASA Amerika'nın 250. yılı için göklerde",
                url: "https://www.nasa.gov",
                authors: [HaberYanitiAuthor(name: "NASA")],
                imageURL: "https://www.nasa.gov/wp-content/uploads/2026/07/55374566234-d7c31b6e97-o.jpg",
                publishedAt: .now,
                summary: "NASA yöneticisi, Ulusal Meydan üzerinde düzenlenen geçit töreninde kişisel uçağıyla bir gösteri uçuşuna öncülük etti. 250 yıldır Amerika mümkün olanın sınırlarını zorluyor."
              
            )
        )
    }
}
