//
//  AramaViewModel.swift
//  Haberler
//
//  Created by Merve Akçakaya on 21.07.2026.
//

import Foundation
import Combine

class AramaViewModel: ObservableObject {
    @Published var aramaMetni = ""
    @Published private(set) var sonuclar: [HaberYaniti] = []
    @Published private(set) var araniyor = false

    private let service: HaberService
    private var cancellables = Set<AnyCancellable>()

    init(service: HaberService = HaberService()) {
        self.service = service
        baglantiKur()
    }

    private func baglantiKur() {
        $aramaMetni
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] metin in
                Task { await self?.ara(metin) }
            }
            .store(in: &cancellables)
    }

    @MainActor
    private func ara(_ metin: String) async {
        let temiz = metin.trimmingCharacters(in: .whitespaces)
        guard !temiz.isEmpty else {
            sonuclar = []
            return
        }
        araniyor = true
        do {
            sonuclar = try await service.haberAra(metin: temiz)
        } catch {
            print("Arama hatası:", error)
            sonuclar = []
        }
        araniyor = false
    }
}
