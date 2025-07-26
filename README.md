# Shartflix 🎬

Modern ve kullanıcı dostu arayüzü ile film keşfetme ve izleme deneyimi sunan Flutter tabanlı mobil uygulama.

## 📱 Özellikler

- 🎥 Film listesi ve detay sayfaları
- 👤 Kullanıcı kayıt ve giriş sistemi
- 🌓 Açık/Koyu tema desteği
- 🌍 Çoklu dil desteği (Türkçe/İngilizce)
- 📸 Profil fotoğrafı yükleme
- 📱 Responsive tasarım

## 🏗️ Mimari

Bu proje **MVVM (Model-View-ViewModel)** mimarisi kullanılarak geliştirilmiştir. Temiz kod prensipleri ve modüler yapı benimsenmiştir.

### Proje Yapısı

```
lib/
├── main.dart                 # Uygulama giriş noktası
├── models/                   # Veri modelleri
├── modules/                  # UI katmanları (View & ViewModel)
│   ├── home/
│   ├── login/
│   ├── register/
│   ├── profile/
│   ├── photo_upload/
│   └── splash/
├── repositories/             # Veri erişim katmanı
├── services/                 # İş mantığı servisleri
├── theme/                    # Tema konfigürasyonları
├── utils/                    # Yardımcı fonksiyonlar
└── widgets/                  # Tekrar kullanılabilir bileşenler
```

### Mimari Bileşenler

- **Views**: UI bileşenleri, kullanıcı etkileşimlerini yönetir
- **ViewModels**: İş mantığı ve state yönetimi
- **Repositories**: API çağrıları ve veri işlemleri
- **Services**: Uygulama genelinde kullanılan servisler
- **Models**: Veri transferi için kullanılan sınıflar

## 📦 Kullanılan Ana Paketler

### State Management & Architecture

- **[stacked](https://pub.dev/packages/stacked)** `^3.4.4` - MVVM mimarisi ve state yönetimi için

### Network & API

- **[dio](https://pub.dev/packages/dio)** `^5.8.0+1` - HTTP istekleri ve API entegrasyonu

### Storage & Persistence

- **[shared_preferences](https://pub.dev/packages/shared_preferences)** `^2.5.3` - Local veri saklama

### Internationalization

- **[easy_localization](https://pub.dev/packages/easy_localization)** `^3.0.8` - Çoklu dil desteği

### UI & Animation

- **[animate_do](https://pub.dev/packages/animate_do)** `^4.2.0` - Önceden tanımlanmış animasyonlar
- **[google_fonts](https://pub.dev/packages/google_fonts)** `^6.1.0` - Google Fonts entegrasyonu
- **[cached_network_image](https://pub.dev/packages/cached_network_image)** `^3.3.1` - Optimized görsel yükleme

### Media & Permissions

- **[image_picker](https://pub.dev/packages/image_picker)** `^1.0.4` - Galeri/kamera erişimi
- **[permission_handler](https://pub.dev/packages/permission_handler)** `^11.3.1` - İzin yönetimi
- **[image](https://pub.dev/packages/image)** `^4.0.17` - Görsel işleme

### Utility

- **[url_launcher](https://pub.dev/packages/url_launcher)** `^6.2.2` - URL açma işlemleri

## 🚀 Kurulum

### Gereksinimler

- Flutter SDK (>=3.2.3 <4.0.0)
- Dart SDK
- Android Studio / VS Code
- Android SDK / iOS SDK

### Adımlar

1. **Proje klonlama**

```bash
git clone [repository-url]
cd shartflix
```

2. **Bağımlılıkları yükleme**

```bash
flutter pub get
```

3. **Launcher ikonlarını oluşturma**

```bash
flutter pub run flutter_launcher_icons:main
```

4. **Uygulamayı çalıştırma**

```bash
flutter run
```

## 🛠️ Geliştirme

### Build komutu

```bash
flutter build apk --release
```

### Test çalıştırma

```bash
flutter test
```

### Code generation (gerekirse)

```bash
flutter packages pub run build_runner build
```

## 🌍 Çoklu Dil Desteği

Uygulama şu dilleri destekler:

- 🇹🇷 Türkçe
- 🇺🇸 İngilizce

Yeni dil eklemek için `assets/translations/` klasörüne ilgili JSON dosyasını ekleyin.

## 🎨 Tema Sistemi

- Açık tema (Light Theme)
- Koyu tema (Dark Theme)
- Sistem teması takip etme
- Kullanıcı tercihi kaydetme

## 📱 Desteklenen Platformlar

- ✅ Android
- ✅ iOS
- ✅ Web (sınırlı)
- ✅ macOS (sınırlı)
- ✅ Windows (sınırlı)
- ✅ Linux (sınırlı)

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Branch'i push edin (`git push origin feature/AmazingFeature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 📞 İletişim

Sorularınız için [GitHub Issues](../../issues) bölümünü kullanabilirsiniz.
