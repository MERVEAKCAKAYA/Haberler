//
//  HaberService.swift
//  Haberler
//
//  Created by Merve Akçakaya on 6.07.2026.
//

import Foundation

class HaberService {
    private let limit = 20   // her sayfada kaç haber

    func fetchHaber(offset: Int) async throws -> HaberListesiYaniti {
        // URL'i parçalardan güvenli şekilde kur
        var components = URLComponents(string: "https://api.spaceflightnewsapi.net/v4/articles/")!
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        let url = components.url!

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(HaberListesiYaniti.self, from: data)
    }
    
    func haberAra(metin: String) async throws -> [HaberYaniti] {
        var components = URLComponents(string: "https://api.spaceflightnewsapi.net/v4/articles/")!
        components.queryItems = [
            URLQueryItem(name: "title_contains", value: metin),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        let url = components.url!

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(HaberListesiYaniti.self, from: data).results
    }
}
