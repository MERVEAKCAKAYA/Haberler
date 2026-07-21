//
//  Haber.swift
//  Haberler
//
//  Created by Merve Akçakaya on 6.07.2026.
//

import Foundation

// API'nin döndürdüğü dış sarmalayıcı yapı: { count, next, previous, results: [...] }
struct HaberListesiYaniti: Codable {
    let count: Int
    let results: [HaberYaniti]
}

struct HaberYaniti: Codable, Identifiable, Hashable{
    let id: Int
    let title: String
    let url: String
    let authors: [HaberYanitiAuthor]
    let imageURL: String
    let publishedAt: Date
    let summary: String

    enum CodingKeys: String, CodingKey {
        case id, title, url, authors, summary
        case imageURL = "image_url"
        case publishedAt = "published_at"
    }
}

struct HaberYanitiAuthor: Codable, Hashable{
    let name: String
    // Not: API'deki "socials" alanı bazen null bazen obje ({ x, youtube, ... })
    // geliyor. Kullanmadığımız için modele almıyoruz; Codable bu alanı yok sayar.
}
