//
//  HaberService.swift
//  Haberler
//
//  Created by Merve Akçakaya on 6.07.2026.
//

import Foundation

class HaberService {
    func fetchHaber() async throws -> [HaberYaniti] {
        let url = URL(string: "https://api.spaceflightnewsapi.net/v4/articles/")!
        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601   // published_at ISO8601 formatında

        let yanit = try decoder.decode(HaberListesiYaniti.self, from: data)
        return yanit.results
    }
}
