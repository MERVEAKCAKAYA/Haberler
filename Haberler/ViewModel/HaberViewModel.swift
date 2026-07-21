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

    private var offset = 0          // şu ana kadar kaç haber yüklendi
    private var toplam = 0          // API'deki count (toplam haber sayısı)
    private(set) var isLoadingMore = false   // şu an sonraki sayfa yükleniyor mu?

    init(service: HaberService = HaberService()) {
        self.service = service
    }

    // İlk yükleme (sayfa 1)
    func loadData() async {
        durum = .yukleniyor
        offset = 0
        do {
            let yanit = try await service.fetchHaber(offset: offset)
            offset = yanit.results.count
            toplam = yanit.count
            durum = .basarili(yanit.results)
        } catch let hata as DecodingError {
            print("Decode hatası: \(hata)")
            durum = .hata("Veri çözümlenemedi")
        } catch {
            durum = .hata(error.localizedDescription)
        }
    }

    // Sonraki sayfalar
    func loadMore() async {
        // 1. Sadece "basarili" durumdaysak ve mevcut listeyi elde et
        guard case .basarili(let mevcut) = durum else { return }
        // 2. Zaten yükleniyorsa VEYA hepsini yüklediysek dur
        guard !isLoadingMore, offset < toplam else { return }

        isLoadingMore = true
        do {
            let yanit = try await service.fetchHaber(offset: offset)
            let yeni = mevcut + yanit.results     // append!
            offset = yeni.count
            toplam = yanit.count
            durum = .basarili(yeni)
        } catch {
            print("loadMore hatası: \(error)")    // sessizce geç, liste kalsın
        }
        isLoadingMore = false
    }
}
