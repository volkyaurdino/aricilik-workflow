# 🐝 Arıcılık Workflow — Proje Seyir Defteri

## Projenin amacı

Android telefon üzerinde çalışan, Blender'ın node editörüne benzer
görsel bir arıcılık eğitim ve simülasyon sistemi geliştirmek.

Kullanıcı arıcılık süreçlerini node'lar ile oluşturabilecek,
node'ları birbirine bağlayabilecek ve oluşturduğu sistemi
simülasyon olarak çalıştırabilecek.

---

## 🟢 v0.1 — İlk çalışan prototip

Durum: BAŞARILI

### Tamamlananlar

- Flutter tabanlı Android proje yapısı oluşturuldu.
- GitHub repository oluşturuldu.
- GitHub Actions ile otomatik APK üretimi kuruldu.
- APK başarıyla derlendi.
- APK Android telefona kuruldu ve çalıştırıldı.
- Koyu renkli node çalışma alanı oluşturuldu.
- İlk arıcılık node'ları oluşturuldu:
  - 🌦️ İklim
  - 🌼 Flora
  - 🐝 Koloni
  - 🏠 Kovan
  - 🍯 Üretim
- Node'ların sürüklenebilmesi için temel yapı oluşturuldu.
- Node'lar arasında görsel bağlantılar oluşturuldu.

### Önemli dosyalar

- `lib/main.dart` — Ana uygulama ve node editörü
- `pubspec.yaml` — Flutter proje ayarları
- `.github/workflows/build-apk.yml` — Otomatik APK üretimi

---

## 🔵 Sıradaki sürüm: v0.2

Planlanan özellikler:

- Node taşıma sistemini geliştirme
- Çalışma alanında pan
- İki parmakla zoom
- Node giriş ve çıkış bağlantıları
- Parmağı sürükleyerek node'lar arasında bağlantı kurma
- `+` düğmesi ile yeni node oluşturma

---

## 📌 Çalışma yöntemi

ChatGPT:
tasarım, mimari, kodlama ve hata çözümü

GitHub:
kaynak kod ve sürüm geçmişi

GitHub Actions:
Android APK oluşturma

Android telefon:
uygulamanın gerçek cihaz testi

---

## Son durum

v0.1 telefonda başarıyla çalışıyor.

Sonraki hedef:
v0.2 — gerçek etkileşimli node editörü.
