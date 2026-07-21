//
//  CachedImage.swift
//  Haberler
//
//  Created by Merve Akçakaya on 21.07.2026.
//
/*
 AsyncImage'in yerine gececek olan ve ImageLoader'ı kullanacak olan
 view'dır.
 */
import SwiftUI

struct CachedImage: View {
    let urlString : String
    @State private var uiImage: UIImage?
    
    var body: some View {
        Group{
            if let uiImage = uiImage {
                Image(uiImage: uiImage).resizable().scaledToFill()
            }else{
                ProgressView()
            }
        }
        .task {
            await load()
        }
    }
    private func load() async {
            guard uiImage == nil else { return }
            guard let url = URL(string: urlString) else { return }
            uiImage = try? await ImageLoader.shared.image(from: url)
        }
}

#Preview {
    CachedImage(urlString: "WWW.GOOGLE.COM")
}
