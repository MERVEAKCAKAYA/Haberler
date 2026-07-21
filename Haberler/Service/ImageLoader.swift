//
//  ImageLoader.swift
//  Haberler
//
//  Created by Merve Akçakaya on 21.07.2026.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private init() {}

    private let cache = NSCache<NSURL, UIImage>()

    func image(from url: URL) async throws -> UIImage {
        // 1. Cache'te var mı? Varsa hemen ver (cache hit)
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }
        // 2. Yoksa internetten indir (cache miss)
        let (data, _) = try await URLSession.shared.data(from: url)

        // 3. Gelen ham veriyi (data) görsele çevir
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }

        // 4. Cache'e koy ki bir dahakine indirmeyelim
        cache.setObject(image, forKey: url as NSURL)

        // 5. Görseli döndür
        return image
    }
}
