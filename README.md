# 🚀 Akıllı İK CV Değerlendirme ve LLM Sıralama Sistemi (MATLAB)

Bu proje, Yazılım Mühendisliği dersi kapsamında geliştirilmiş, yapay zeka ve Büyük Dil Modelleri (LLM) tabanlı bir İnsan Kaynakları (İK) karar destek sistemidir. Kaggle'dan temin edilen yapılandırılmış özgeçmiş (CV) veri setlerini analiz eder, belirlenen iş ilanı kriterlerine göre nesnel puanlamalar yapar ve en uygun adayları ilişkisel olarak sıralar.

## 📌 Projenin Amacı
Geleneksel İnsan Kaynakları süreçlerinde yüzlerce CV'nin manuel olarak incelenmesi büyük bir zaman kaybıdır. Bu sistem; Doğal Dil İşleme (NLP), metin önişleme, **Prompt Mühendisliği** ve **Google Gemini 2.5 Flash** entegrasyonu ile otonom bir aday filtreleme ve sıralama algoritması (pipeline) kurar. Proje tamamen **MATLAB** ortamında nesneye yönelik (Struct/Table) mantığıyla geliştirilmiştir.

## 🛠️ Kullanılan Teknolojiler ve Mimari
- **MATLAB:** Ana programlama dili ve veri işleme ortamı.
- **Google Gemini 2.5 Flash API (LLM):** Metin tabanlı içerikleri anlamlandırma ve değerlendirme.
- **Veri Yapıları:** `table` (ilişkisel tablo yönetimi), `struct` (JSON parsing).
- **Ağ Entegrasyonu (REST API):** `webwrite`, `weboptions` (HTTP POST iletişimi).
- **Metin Madenciliği:** `regexprep`, `strtrim` (Düzenli ifadeler ile veri temizliği).
- **Veri Seti:** Kaggle Resume Dataset.

## 📂 Dosya Yapısı
1. **`main.m`**: Veri setini okuyan (`readtable`), adayların farklı sütunlardaki bilgilerini birleştirip (`sprintf`) döngüye sokan ve sonuçları `sortrows` ile sıralayan ana betik.
2. **`cleanResume.m`**: Ham CV metnindeki URL, özel karakter ve boşlukları düzenli ifadeler (`regexprep`) ile temizleyen önişleme fonksiyonu.
3. **`evaluateResumeWithLLM.m`**: Hazırlanan özel Prompt'u Google Gemini API'sine HTTP POST isteğiyle gönderen ve dönen yanıtı JSON yakalayıcı (Catcher) algoritmasıyla ayrıştıran fonksiyon.

## 🚀 Çalışma Adımları (Data Pipeline)
1. **Veri Okuma:** Kaggle verisi MATLAB'in optimize tablo yapısına aktarılır.
2. **Metin Birleştirme ve Temizleme:** Adayın yetenekleri, okulu ve deneyimi birleştirilir, gereksiz karakterlerden arındırılır.
3. **Prompt Mühendisliği & API İsteği:** Temizlenen veri, hedef iş ilanı kriterleriyle harmanlanıp LLM'e "Sen bir İK uzmanısın" rolüyle gönderilir.
4. **JSON Parsing & Hata Yönetimi:** Modelin ürettiği metinsel veriler, kod bloğunda yazılan özel bir "JSON Catcher" yardımıyla çekilir ve MATLAB `struct` yapısına çevrilir (`jsondecode`).
5. **Vektörel Sıralama:** Çekilen puanlar ana tabloyla ilişkilendirilerek büyükten küçüğe sıralanır.

## ⚙️ Kurulum ve Kullanım
1. Repoyu bilgisayarınıza klonlayın.
2. `UpdatedResumeDataset.csv` isimli Kaggle veri setini proje dizinine ekleyin.
3. [Google AI Studio](https://aistudio.google.com/) üzerinden ücretsiz bir Gemini API anahtarı alın.
4. `evaluateResumeWithLLM.m` dosyasının içindeki `apiKey` değişkenine kendi anahtarınızı girin.
5. MATLAB üzerinden `main.m` dosyasını çalıştırın (Run).
