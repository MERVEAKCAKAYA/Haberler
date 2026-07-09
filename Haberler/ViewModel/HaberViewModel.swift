//
//  HaberViewModel.swift
//  Haberler
//
//  Created by Merve Akçakaya on 6.07.2026.
//

import Foundation

@Observable
class HaberViewModel {
    enum Durum {
        case yukleniyor
        case basarili([HaberYaniti])
        case hata(String)
    }
    var durum: Durum = .yukleniyor
    private let service: HaberService

    init(service: HaberService = HaberService()) {
        self.service = service
    }

    func loadData() async {
        durum = .yukleniyor
        do {
            let haberler = try await service.fetchHaber()
            durum = .basarili(haberler)
        } catch let hata as DecodingError {
            // Konsola gerçek sebebi bas (hangi alan / hangi tip)
            print("Decode hatası: \(hata)")
            durum = .hata("Veri çözümlenemedi")
        } catch {
            durum = .hata(error.localizedDescription)
        }
    }
}
