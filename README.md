# Haberler 📰

SwiftUI ile geliştirilen, uzay/havacılık haberlerini listeleyen ve arayan bir iOS uygulaması. [Spaceflight News API](https://api.spaceflightnewsapi.net/v4/docs/) üzerinden canlı veri çeker.

Uygulama, modern iOS geliştirme kalıplarını öğrenmek ve pratik etmek amacıyla adım adım geliştirildi: MVVM, async/await ile ağ katmanı, kendi görsel önbelleği, sonsuz kaydırma (pagination) ve Combine ile debounce'lu arama.

## Özellikler

- [x] API'den canlı haber listesi
- [x] Haber detay sayfası (kapak görseli, yazar, tarih, özet, kaynağa git)
- [x] Bellek içi görsel önbelleği (image caching)
- [x] Sonsuz kaydırma (offset tabanlı pagination)
- [x] Debounce'lu arama (Combine)

## Mimari

Proje **MVVM** (Model–View–ViewModel) yapısında, klasörler sorumluluklara göre ayrılmıştır:

```
Haberler/
├── Model/
│   └── Haber.swift              # Codable veri modelleri (HaberYaniti, sarmalayıcı)
├── Service/
│   ├── HaberService.swift       # API çağrıları (liste, arama)
│   └── ImageLoader.swift        # NSCache tabanlı görsel önbelleği
├── ViewModel/
│   ├── HaberViewModel.swift     # Liste + pagination durumu (@Observable)
│   └── AramaViewModel.swift     # Combine ile arama (ObservableObject)
└── View/
    ├── HaberView.swift          # Haber listesi
    ├── HaberDetayView.swift     # Haber detayı
    ├── AramaView.swift          # Arama ekranı
    └── CachedImage.swift        # Önbellekli görsel bileşeni
```

## Öne çıkan yapılar

### 1. MVVM + `@Observable`
Liste ekranı, yeni **Observation** framework'ü (`@Observable`) ile yönetiliyor. ViewModel bir **durum makinesi** tutuyor (`yukleniyor` / `basarili` / `hata`), View bu duruma göre çiziliyor. Ağ, iş mantığı ve gösterim birbirinden ayrık.

### 2. Ağ katmanı — async/await + Codable
`HaberService`, `URLSession` + `async/await` ile veriyi çekip `Codable` modellere çözüyor. URL'ler string birleştirme yerine **`URLComponents` + `URLQueryItem`** ile kuruluyor (parametreler otomatik ve doğru kodlanıyor). API `snake_case` alanları `CodingKeys` ile eşleniyor, tarihler `.iso8601` stratejisiyle çözülüyor.

### 3. Görsel önbelleği (image caching)
`AsyncImage` her görünüşte görseli yeniden indirdiği için kendi çözümümüz yazıldı:
- **`ImageLoader`** → `NSCache<NSURL, UIImage>` ile bellek önbelleği. Mantık: *önce önbelleğe bak → yoksa indir → önbelleğe koy → ver.* `NSCache` bellek daralınca kendini otomatik temizler.
- **`CachedImage`** → `AsyncImage`'in yerine geçen, arkada `ImageLoader`'ı kullanan SwiftUI bileşeni. Liste kaydırıldığında aynı görseller tekrar inmez.

### 4. Sonsuz kaydırma (pagination)
API'nin `limit` / `offset` parametreleriyle **offset tabanlı** sayfalama:
- `HaberViewModel` sonuçları **biriktirir** (append), `offset` ve toplam `count`'u takip eder.
- **Duplicate istek koruması** (`isLoadingMore` bayrağı) ve "daha var mı?" kontrolü (`offset < toplam`) ile gereksiz/mükerrer çağrılar engellenir.
- View'de son satır göründüğünde bir sonraki sayfa yüklenir, altta bir yükleniyor göstergesi çıkar.

### 5. Combine ile arama — mevcut yapıya dokunmadan
Arama özelliği, **Combine öğrenmek** için bilinçli olarak Combine ile yazıldı. Önemli tasarım kararı: proje `@Observable` kullanırken Combine'in klasik `@Published` + `ObservableObject` kalıbı buna doğrudan uymadığı için, **mevcut yapı hiç değiştirilmedi**. Bunun yerine Combine, tamamen **ayrı ve bağımsız** bir `AramaViewModel` (`ObservableObject`) içinde, kendi köşesinde yaşıyor:

```
.searchable → @Published aramaMetni → debounce(300ms) → removeDuplicates → sink → API araması
```

- `.searchable` yalnızca kullanıcının yazdığını `@Published` değişkene yazar.
- **`debounce`** kullanıcı yazmayı bırakana kadar bekler; her harfte istek atılmasını önler.
- **`removeDuplicates`** aynı aramanın tekrarını eler.
- Abonelik `init` içinde bir kez kurulur ve `Set<AnyCancellable>` içinde canlı tutulur; ViewModel yok olunca otomatik iptal olur.

Böylece `HaberViewModel`'in `@Observable` yapısı ile `AramaViewModel`'in Combine yapısı aynı projede, birbirine karışmadan yan yana çalışır.

## Teknolojiler

- **Swift**, **SwiftUI**, **Combine**
- **Swift Concurrency** (async/await)
- **Observation** (`@Observable`)
- **NSCache** (görsel önbelleği)
- [Spaceflight News API v4](https://api.spaceflightnewsapi.net/v4/docs/)

## Kurulum

```bash
git clone https://github.com/MERVEAKCAKAYA/Haberler.git
cd Haberler
open Haberler.xcodeproj
```

Ardından Xcode üzerinden bir simülatör seçip **Run** (`⌘R`) ile çalıştırabilirsin. API anahtarı gerekmez.

## Gereksinimler

- Xcode 15+
- iOS 17+

## Lisans

Bu proje kişisel bir çalışmadır.
