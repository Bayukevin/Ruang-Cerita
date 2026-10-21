import os, textwrap, pypandoc

out_path = "/mnt/data/PRD_Ruang_Cerita_GAS.md"

md = r"""# PRODUCT REQUIREMENTS DOCUMENT (PRD)
## Ruang Cerita: Integrasi Flutter, Google Apps Script, dan Gemini API

**Versi:** 2.0  
**Status:** Acuan implementasi  
**Platform awal:** Android  
**Bahasa aplikasi:** Indonesia  
**Backend:** Google Apps Script Web App  
**Autentikasi:** Firebase Authentication  
**AI:** Gemini API melalui Google Apps Script  
**Penyimpanan riwayat MVP:** Lokal pada perangkat  
**Endpoint deployment saat ini:**

`https://script.google.com/macros/s/AKfycbwXI_wDt3OInJYy610B24-AZ0WAzITUgvnZnX3U0mXWEmLU70_Ajlrzc50hlc9NElzPqA/exec`

> **Catatan integrasi penting:** endpoint health telah dilaporkan aktif, tetapi health check tidak membuktikan nama action dan format request/response untuk generate AI. Sebelum integrasi final, cocokkan kontrak API dengan kode Google Apps Script yang benar-benar sedang di-deploy. PRD ini menetapkan kontrak target untuk menyatukan Flutter dan backend.

---

# 1. Ringkasan Produk

Ruang Cerita adalah aplikasi pendamping refleksi kesehatan mental berbasis pilihan. Aplikasi membantu pengguna mengenali perasaan, memilih konteks yang relevan, menjawab pertanyaan singkat, lalu menerima rangkuman suportif dan saran praktis yang dihasilkan oleh Gemini API.

Pengguna tidak diwajibkan mengetik jawaban bebas dalam alur refleksi utama. Mereka memilih opsi yang disediakan. Pertanyaan dan respons dapat dibacakan melalui Text-to-Speech (TTS) di perangkat.

Ruang Cerita bukan alat diagnosis, bukan pengganti psikolog atau tenaga kesehatan, dan bukan layanan darurat. Respons AI harus menggunakan bahasa yang tidak menghakimi, tidak mengklaim kepastian klinis, dan tidak mendorong ketergantungan kepada AI.

## 1.1 Tujuan dokumen

Dokumen ini menjadi pedoman bagi pengembangan Flutter yang sudah ada. Implementasi harus memanfaatkan struktur dan desain saat ini, bukan membangun ulang aplikasi dari awal.

PRD ini menetapkan:
- batas tanggung jawab Flutter, Google Apps Script, Firebase Authentication, dan Gemini API;
- kontrak request dan response;
- pemetaan pilihan UI ke ID internal;
- pengelolaan loading, error, timeout, dan respons keselamatan;
- implementasi TTS dan penyimpanan riwayat lokal;
- keamanan, privasi, pengujian, dan kriteria penerimaan.

## 1.2 Kondisi proyek menurut audit

Hal-hal berikut berasal dari laporan audit kode yang diberikan:
- UI layar utama telah tersedia, termasuk onboarding, autentikasi, beranda empat tab, alur refleksi, latihan pernapasan, Pusat Bantuan Aman, dan Riwayat & Privasi.
- Firebase Authentication email/password dan Google Sign-In sudah berfungsi.
- `AuthService` sudah tersedia dan harus dipertahankan. Tambahkan kemampuan mengambil Firebase ID token tanpa merombak login yang ada.
- Konten pertanyaan dan rangkuman AI masih statis.
- Belum ada API client, model request/response, atau integrasi Google Apps Script di `lib/`.
- `flutter_tts` dan `shared_preferences` sudah ada di `pubspec.yaml`, tetapi belum dipakai.
- Riwayat saat ini hanya berupa data contoh di memori dan belum persisten.
- Google Apps Script health endpoint telah dilaporkan merespons sukses setelah redirect HTTP.
- Nama action dan format payload yang benar pada deployment belum terverifikasi.

Temuan di atas menjadi baseline. Developer harus memeriksa ulang kode lokal sebelum mengubah file.

---

# 2. Sasaran dan Bukan Sasaran

## 2.1 Sasaran MVP

1. Mempertahankan login dan registrasi Firebase yang sudah berfungsi.
2. Menghubungkan alur refleksi Flutter ke Google Apps Script.
3. Mengirim pilihan perasaan, situasi, durasi, tujuan dukungan, dan jawaban terstruktur.
4. Memvalidasi Firebase ID token di backend sebelum menjalankan action privat.
5. Meminta Gemini menghasilkan respons refleksi dengan struktur yang konsisten.
6. Menampilkan respons AI pada layar Rangkuman Hangat AI.
7. Membacakan pertanyaan dan respons menggunakan TTS perangkat.
8. Menyimpan refleksi hanya jika pengguna memilih menyimpan, menggunakan penyimpanan lokal untuk MVP.
9. Menyediakan penanganan error dan jalur bantuan aman yang tidak bergantung pada keberhasilan Gemini.
10. Menguji integrasi di Android debug dan release build.

## 2.2 Bukan sasaran MVP

- Diagnosis gangguan mental.
- Skor kesehatan mental atau probabilitas klinis.
- Menggantikan konsultasi profesional.
- Chat bebas tanpa batas.
- Penyimpanan seluruh percakapan ke Google Sheets atau log Apps Script.
- Sinkronisasi riwayat lintas perangkat.
- Firestore sebagai penyimpanan riwayat, kecuali diputuskan sebagai fase lanjutan.
- TTS cloud berbayar. MVP memakai mesin TTS perangkat.
- Sistem notifikasi atau pemantauan kondisi pengguna secara otomatis.

---

# 3. Pengguna dan Prinsip Pengalaman

## 3.1 Pengguna sasaran

Masyarakat umum yang ingin melakukan refleksi singkat dan memperoleh dukungan emosional dasar. Antarmuka harus mudah digunakan oleh orang yang tidak terbiasa menulis jurnal atau mengetik panjang.

## 3.2 Prinsip UX

- **Pilihan, bukan kewajiban mengetik:** gunakan pilihan terstruktur pada alur utama.
- **Satu pertanyaan pada satu waktu:** kurangi beban kognitif.
- **Suara opsional:** pengguna tetap bisa memakai aplikasi tanpa suara.
- **Tidak menghakimi:** hindari kata yang menyalahkan atau meremehkan.
- **Transparansi AI:** jelaskan bahwa respons dibuat AI dan bukan diagnosis.
- **Kontrol pengguna:** pengguna bisa berhenti, kembali, tidak menjawab, dan memilih apakah refleksi disimpan.
- **Akses bantuan mudah:** Pusat Bantuan Aman dapat dibuka kapan pun.

---

# 4. Arsitektur Teknis

## 4.1 Gambaran arsitektur

```text
Flutter Android
  ├── Firebase Authentication SDK
  │     ├── Email/password
  │     └── Google Sign-In
  ├── ApiService
  │     └── HTTPS POST JSON
  │           ↓
  │      Google Apps Script Web App
  │        ├── Validasi action dan input
  │        ├── Validasi Firebase ID token
  │        ├── Aturan keselamatan
  │        ├── Pembatasan request dasar
  │        └── Panggilan Gemini API
  │                  ↓
  │             Gemini API
  │                  ↓
  │      Validasi dan normalisasi output
  │                  ↓
  ├── Menampilkan hasil AI
  ├── Text-to-Speech lokal
  ├── Latihan pernapasan lokal
  └── SharedPreferences untuk refleksi tersimpan
```

## 4.2 Pembagian tanggung jawab

### Flutter
- UI, navigasi, pilihan pengguna, state sesi, dan validasi ringan.
- Mendapatkan Firebase ID token melalui Firebase SDK.
- Mengirim request ke Apps Script.
- Menangani loading, timeout, error, dan respons.
- Menampilkan hasil terstruktur.
- Menjalankan TTS di perangkat.
- Menjalankan latihan pernapasan.
- Menyimpan refleksi yang dipilih pengguna pada penyimpanan lokal.

### Firebase Authentication
- Login email/password dan Google Sign-In.
- Mengelola sesi pengguna.
- Menghasilkan ID token untuk membuktikan identitas kepada backend.

### Google Apps Script
- Menjadi endpoint backend.
- Memvalidasi payload.
- Memeriksa Firebase ID token melalui Firebase Authentication REST API atau metode verifikasi tepercaya yang dipilih.
- Menerapkan pemeriksaan keselamatan sebelum generasi AI.
- Memanggil Gemini API menggunakan API key dari Script Properties.
- Memvalidasi struktur output AI.
- Mengembalikan respons JSON yang konsisten.
- Tidak menyimpan isi refleksi atau token ke log.

### Gemini API
- Menghasilkan rangkuman refleksi, validasi perasaan, langkah praktis, dan pesan penutup.
- Tidak menentukan diagnosis.
- Tidak memutuskan sendiri apakah pengguna berada dalam keadaan darurat. Aturan keselamatan di aplikasi/backend harus diprioritaskan.

## 4.3 Konfigurasi backend

URL deployment:

`https://script.google.com/macros/s/AKfycbwXI_wDt3OInJYy610B24-AZ0WAzITUgvnZnX3U0mXWEmLU70_Ajlrzc50hlc9NElzPqA/exec`

URL bukan secret. Keamanan tidak boleh bergantung pada kerahasiaan URL.

Script Properties yang diperlukan:
- `GEMINI_API_KEY`: API key Gemini.
- `FIREBASE_WEB_API_KEY`: Web API Key proyek Firebase yang dipakai untuk pemeriksaan token melalui endpoint Firebase Authentication.
- `GEMINI_MODEL`: nama model Gemini yang memang tersedia dan diaktifkan untuk proyek tersebut.

Jangan pernah menyimpan `GEMINI_API_KEY` dalam source Flutter, APK, atau repositori.

---

# 5. Alur Pengguna

## 5.1 Onboarding dan autentikasi

1. Pengguna membuka aplikasi.
2. Aplikasi memeriksa sesi Firebase.
3. Jika belum login, tampilkan onboarding lalu login/register sesuai navigasi yang sudah ada.
4. Jika sudah login, masuk ke beranda.
5. Pertahankan `AuthService` dan alur login yang sudah stabil.
6. Tambahkan method `getIdToken()` untuk mengambil token pengguna yang aktif ketika request privat akan dikirim.

Catatan: audit menyatakan Splash Screen saat ini dilewati oleh `main.dart`. Perbaikan alur splash boleh dilakukan sebagai tugas UI terpisah, tetapi bukan syarat integrasi API.

## 5.2 Alur refleksi

1. Pengguna menekan **Mulai Refleksi**.
2. Pengguna memilih perasaan.
3. Pengguna memilih situasi.
4. Pengguna memilih durasi perasaan.
5. Flutter membuat objek sesi terstruktur.
6. Jika diperlukan, Flutter mengirim pilihan ke Apps Script untuk mendapatkan pertanyaan lanjutan yang sudah dikurasi.
7. Sebelum mengirim sesi untuk generasi AI, aplikasi menjalankan alur pemeriksaan keselamatan yang sesuai dengan desain. Pilihan berisiko harus mengarahkan pengguna ke Pusat Bantuan Aman dan tidak dilanjutkan sebagai refleksi biasa.
8. Flutter mengirim request `generate_reflection`.
9. Apps Script memvalidasi ID token dan payload.
10. Apps Script menerapkan aturan keselamatan.
11. Jika aman untuk dilanjutkan, Apps Script memanggil Gemini.
12. Apps Script memvalidasi output dan mengembalikan JSON.
13. Flutter menampilkan rangkuman, validasi perasaan, langkah praktis, pesan penutup, dan saran latihan.
14. Pengguna dapat mendengarkan respons, mencoba latihan napas, menyimpan refleksi, atau menyelesaikan sesi.

## 5.3 Alur saat API gagal

- Tampilkan pesan yang ramah dan tidak teknis.
- Pertahankan pilihan sesi selama layar masih aktif agar pengguna tidak harus mengulang dari awal.
- Sediakan tombol **Coba Lagi** untuk error sementara.
- Hindari retry otomatis berulang karena dapat menghasilkan request dan biaya API ganda.
- Jangan menampilkan stack trace, token, API key, atau detail internal.
- Pusat Bantuan Aman dan latihan pernapasan lokal harus tetap bisa dibuka tanpa internet.

Contoh pesan:
- Offline: “Koneksi internet belum tersedia. Pilihanmu tetap ada. Coba lagi saat koneksi kembali.”
- Timeout: “Respons belum berhasil diterima. Kamu bisa mencoba lagi.”
- Sesi login berakhir: “Sesi masukmu perlu diperbarui. Silakan masuk kembali.”
- Gangguan server: “Ruang Cerita sedang mengalami kendala. Kamu masih bisa menggunakan latihan pernapasan atau membuka Pusat Bantuan Aman.”

---

# 6. Data Pilihan dan Standarisasi ID

Audit menemukan ketidakkonsistenan: layar perasaan mengirim label tampilan, sedangkan layar situasi mengirim ID internal. Sebelum integrasi, semua pilihan harus dikirim sebagai ID stabil, bukan label UI.

## 6.1 Perasaan

| ID internal | Label UI |
|---|---|
| `cemas` | Cemas |
| `sedih` | Sedih |
| `marah` | Marah |
| `lelah` | Lelah |
| `kesepian` | Kesepian |
| `bingung` | Bingung |
| `baik` | Baik saja |
| `belum-tahu` | Belum tahu |

## 6.2 Situasi

| ID internal | Label UI |
|---|---|
| `keluarga` | Keluarga |
| `pertemanan` | Pertemanan |
| `pekerjaan` | Sekolah atau Pekerjaan |
| `hubungan` | Hubungan |
| `diri` | Diriku Sendiri |
| `lain` | Hal Lain |
| `belum-tahu` | Belum Tahu |

## 6.3 Durasi

| ID internal | Label UI |
|---|---|
| `hari-ini` | Baru hari ini |
| `beberapa-hari` | Beberapa hari |
| `beberapa-minggu` | Beberapa minggu |
| `cukup-lama` | Sudah cukup lama |
| `belum-yakin` | Belum yakin, jika opsi ini ditambahkan |

Jangan mengubah label yang tampil kepada pengguna tanpa alasan desain. Nilai internal boleh distandarkan agar sesuai dengan kontrak backend.

## 6.4 Evaluasi pasca-sesi

| ID internal | Label UI |
|---|---|
| `lega` | Sedikit lebih lega |
| `sama` | Masih sama |
| `berat` | Terasa lebih berat |
| `belum` | Belum tahu |

Evaluasi ini adalah refleksi subjektif pengguna, bukan ukuran klinis atau hasil terapi. MVP boleh menyimpan evaluasi tersebut bersama refleksi lokal jika pengguna menyimpan sesi.

## 6.5 Tujuan dukungan

UI saat ini mempunyai dua tindakan praktis yang ditampilkan sebagai pilihan/aksi:
- Aturan 5 Menit Rehat Layar.
- Minum Air & Longgarkan Pundak.

Jangan menganggap indeks `0` atau `1` sebagai ID backend yang stabil. Jika pilihan ini dikirim ke backend, gunakan ID eksplisit, misalnya `screen_rest_5m` dan `water_shoulder_relax`. Apabila tindakan dipilih setelah respons AI ditampilkan, simpan sebagai interaksi UI, bukan input untuk request awal, kecuali kebutuhan produk menetapkan sebaliknya.

---

# 7. Kontrak API

## 7.1 Aturan umum

- Method: `POST`.
- URL: deployment Apps Script di atas.
- Header: `Content-Type: application/json`.
- Ikuti redirect HTTPS dari Google Apps Script secara otomatis.
- Firebase ID token dikirim di JSON body karena implementasi Web App Apps Script tidak menyediakan akses umum ke custom request headers melalui objek event.
- Jangan kirim password Firebase.
- Jangan kirim data pribadi yang tidak diperlukan.
- Semua action selain health harus memvalidasi token di backend.

### Format payload yang ditetapkan PRD

```json
{
  "action": "generate_reflection",
  "idToken": "<FIREBASE_ID_TOKEN>",
  "data": {
    "feeling": "cemas",
    "situation": "pekerjaan",
    "duration": "beberapa-hari",
    "supportGoal": "sort_thoughts",
    "answers": [],
    "clientTimestamp": "2026-10-20T15:30:00.000Z"
  }
}
```

**Peringatan kompatibilitas:** contoh di atas adalah kontrak target PRD. Audit menyebut action yang tersedia di deployment belum diverifikasi. Kode Apps Script versi sebelumnya menggunakan action `generateReflection` dengan `session` pada level teratas, bukan `generate_reflection` dan `data`. Developer harus menyamakan kode Apps Script dan Flutter ke satu kontrak sebelum implementasi final. Jangan mencampur dua format ini.

## 7.2 Action `health`

Request GET:

`?action=health`

Respons target:

```json
{
  "ok": true,
  "service": "ruang-cerita-backend",
  "version": "1.0.0",
  "timestamp": "..."
}
```

Health check tidak memerlukan ID token dan tidak boleh mengungkap konfigurasi rahasia.

## 7.3 Action `get_question` (opsional pada MVP)

Gunakan hanya jika daftar pertanyaan akan dikelola oleh Apps Script. Jika pertanyaan durasi tetap statis di Flutter, action ini tidak perlu dipanggil pada tahap pertama.

Request:

```json
{
  "action": "get_question",
  "idToken": "<FIREBASE_ID_TOKEN>",
  "data": {
    "step": "follow_up",
    "feeling": "cemas",
    "situation": "pekerjaan"
  }
}
```

Respons target:

```json
{
  "ok": true,
  "data": {
    "questionId": "support_goal_v1",
    "question": "Apa yang paling kamu butuhkan saat rasa cemas muncul?",
    "options": [
      {"id": "calm_body", "label": "Menenangkan tubuh dan napas"},
      {"id": "sort_thoughts", "label": "Merapikan pikiran yang ramai"},
      {"id": "make_plan", "label": "Menentukan satu langkah kecil"},
      {"id": "be_heard", "label": "Didengarkan tanpa dihakimi"}
    ]
  }
}
```

Flutter tidak boleh menganggap pertanyaan lanjutan tersedia sebelum action ini benar-benar diimplementasikan di Apps Script. Untuk MVP awal, pertanyaan statis yang sudah ada boleh dipertahankan.

## 7.4 Action `generate_reflection`

Request:

```json
{
  "action": "generate_reflection",
  "idToken": "<FIREBASE_ID_TOKEN>",
  "data": {
    "feeling": "cemas",
    "situation": "pekerjaan",
    "duration": "beberapa-hari",
    "supportGoal": "sort_thoughts",
    "answers": [
      {
        "questionId": "duration_v1",
        "optionId": "beberapa-hari",
        "label": "Beberapa hari"
      }
    ],
    "safetyConcern": "none"
  }
}
```

Nilai `feeling`, `situation`, dan `duration` harus berasal dari daftar ID yang diizinkan. `answers` dibatasi panjangnya dan harus berisi ID pilihan, bukan teks bebas yang diketik pengguna.

Respons sukses:

```json
{
  "ok": true,
  "requestId": "server-generated-id",
  "data": {
    "summary": "Rangkuman singkat berdasarkan pilihan pengguna.",
    "validation": "Pesan yang mengakui perasaan tanpa membuat asumsi pasti.",
    "practicalStep": {
      "id": "screen_rest_5m",
      "title": "Aturan 5 Menit Rehat Layar",
      "description": "Ambil jeda singkat dan lakukan kegiatan sederhana yang aman."
    },
    "additionalSteps": [
      "Pilih satu tugas kecil yang terasa realistis."
    ],
    "audioScript": "Versi teks yang siap dibacakan.",
    "closingMessage": "Pesan penutup yang suportif.",
    "suggestedExercise": {
      "id": "breathing_1m",
      "title": "Latihan napas 1 menit",
      "durationMinutes": 1
    },
    "isCrisis": false,
    "disclaimer": "Dukungan umum untuk refleksi diri, bukan diagnosis atau pengganti bantuan profesional."
  }
}
```

Kontrak response ini menyesuaikan kebutuhan UI yang tercatat dalam audit. Backend boleh memiliki struktur internal berbeda, tetapi response ke Flutter harus konsisten.

## 7.5 Action keselamatan

Jika action khusus keselamatan diterapkan:

```json
{
  "action": "safety_check",
  "idToken": "<FIREBASE_ID_TOKEN>",
  "data": {
    "safetyConcern": "none"
  }
}
```

Nilai yang diperbolehkan harus didefinisikan dan disepakati bersama. Pilihan berisiko tidak boleh hanya menghasilkan rangkuman biasa dari Gemini. Backend harus mengembalikan flag keselamatan dan Flutter harus menampilkan Pusat Bantuan Aman.

Pemeriksaan keselamatan harus dijalankan sebelum pemanggilan generasi AI jika input mengindikasikan bahaya. Jangan mengandalkan model AI sebagai satu-satunya pemeriksa risiko.

## 7.6 Format error

```json
{
  "ok": false,
  "error": {
    "code": "AUTH_REQUIRED",
    "message": "Autentikasi diperlukan."
  }
}
```

Kode error yang disarankan:
- `INVALID_JSON`
- `INVALID_ACTION`
- `AUTH_REQUIRED`
- `AUTH_INVALID_OR_EXPIRED_TOKEN`
- `INVALID_INPUT`
- `RATE_LIMITED`
- `SAFETY_REDIRECT`
- `GEMINI_REQUEST_FAILED`
- `GEMINI_INVALID_RESPONSE`
- `TIMEOUT`
- `INTERNAL_ERROR`

Flutter harus menggunakan `code` untuk menentukan tindakan dan menampilkan pesan yang ramah. Jangan bergantung pada teks `message` dari server untuk logika aplikasi.

---

# 8. Model Data Dart

Tambahkan folder `lib/models/` jika belum ada. Model berikut adalah sasaran struktur, bukan nama file yang harus dipaksakan apabila proyek telah memiliki pola penamaan lain.

## 8.1 SessionRequest

Properti minimum:
- `feelingId: String`
- `situationId: String`
- `durationId: String`
- `supportGoalId: String?`
- `answers: List<SessionAnswer>`
- `safetyConcern: String?`
- `clientTimestamp: DateTime`

Jangan memasukkan password, API key, token ke dalam model sesi yang disimpan di riwayat. `idToken` hanya ditambahkan saat membentuk request jaringan dan tidak boleh disimpan bersama riwayat.

## 8.2 SessionAnswer

Properti:
- `questionId: String`
- `optionId: String`
- `label: String?`

Label hanya untuk tampilan/debug yang aman. Backend harus memvalidasi ID. Jangan menganggap label UI sebagai nilai otoritatif.

## 8.3 AiReflectionResponse

Properti:
- `summary: String`
- `validation: String`
- `practicalStep: PracticalStep?`
- `additionalSteps: List<String>`
- `audioScript: String`
- `closingMessage: String`
- `suggestedExercise: SuggestedExercise?`
- `isCrisis: bool`
- `disclaimer: String`

Parsing harus tahan terhadap field opsional yang tidak tersedia, tetapi field wajib yang hilang harus diperlakukan sebagai respons tidak valid.

## 8.4 ReflectionRecord

Properti yang disarankan untuk penyimpanan lokal:
- ID lokal unik.
- Waktu sesi.
- ID perasaan dan situasi.
- Durasi pilihan.
- Rangkuman AI.
- Langkah praktis.
- Pesan penutup.
- Evaluasi pasca-sesi jika dipilih.
- Versi skema data.

Jangan simpan Firebase ID token atau Gemini API key. Jangan menyimpan isi refleksi otomatis jika pengguna belum memilih menyimpan.

---

# 9. Struktur File Flutter yang Disarankan

Audit menunjukkan proyek saat ini memiliki `lib/main.dart`, `lib/services/auth_service.dart`, tema, dan layar pada `lib/screens/`. Gunakan struktur berikut sebagai sasaran tambahan:

```text
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   ├── session_request.dart
│   ├── session_answer.dart
│   ├── ai_reflection_response.dart
│   └── reflection_record.dart
├── services/
│   ├── auth_service.dart           # pertahankan, tambah getIdToken()
│   ├── api_service.dart            # baru
│   ├── tts_service.dart            # baru
│   └── storage_service.dart        # baru
├── screens/
│   ├── pilih_perasaan_screen.dart
│   ├── pilih_situasi_screen.dart
│   ├── pertanyaan_adaptif_screen.dart
│   ├── rangkuman_hangat_ai_screen.dart
│   ├── sesi_selesai_screen.dart
│   ├── latihan_pernapasan_screen.dart
│   ├── pusat_bantuan_aman_screen.dart
│   └── riwayat_privasi_screen.dart
└── theme/
    ├── app_colors.dart
    └── app_typography.dart
```

Jangan mengubah nama atau memindahkan file layar yang sudah digunakan oleh routing kecuali benar-benar diperlukan. Perubahan harus kecil, terukur, dan mengikuti struktur aktual.

---

# 10. API Service Flutter

## 10.1 Tanggung jawab

`ApiService` harus:
1. Menggunakan satu base URL konfigurasi.
2. Memastikan pengguna sedang login untuk action privat.
3. Meminta ID token terkini dari Firebase.
4. Mengirim JSON melalui HTTPS POST.
5. Mengikuti redirect yang diperlukan oleh Apps Script.
6. Menetapkan timeout request.
7. Memvalidasi status dan JSON response.
8. Mengembalikan model response, bukan Map mentah ke seluruh widget.
9. Mengubah error teknis menjadi exception/domain error yang dapat ditangani UI.
10. Tidak mencetak token, pilihan pribadi, atau isi refleksi ke log.

## 10.2 Redirect

Audit melaporkan bahwa GET health melewati HTTP 302 lalu 200. Klien HTTP harus mengikuti redirect dengan aman. Uji POST nyata, bukan hanya GET, karena redirect POST dapat memiliki perilaku berbeda pada klien dan runtime.

Pastikan request POST tetap sampai sebagai POST dengan payload yang utuh. Jangan menganggap keberhasilan GET health sebagai bukti bahwa POST Gemini berhasil.

## 10.3 Timeout dan retry

- Timeout awal generasi AI: 25–30 detik, lalu sesuaikan berdasarkan pengujian nyata.
- Jangan retry otomatis untuk setiap timeout, sebab request pertama mungkin sudah diproses.
- Sediakan tombol coba lagi yang jelas.
- Cegah ketukan ganda pada tombol kirim ketika request sedang berjalan.
- Untuk menghindari generasi ganda, tombol harus dinonaktifkan selama loading.
- Jika backend kelak mendukung idempotency key, gunakan ID request sesi agar pengiriman ulang tidak menghasilkan respons dan biaya ganda.

## 10.4 Loading state

Pada layar Rangkuman Hangat AI:
- Tampilkan indikator loading sesuai desain.
- Tampilkan pesan singkat seperti “Sedang menyiapkan rangkuman untukmu”.
- Jangan menampilkan teks refleksi statis seolah-olah itu respons AI.
- Jika request gagal, tampilkan error state dengan opsi coba lagi.
- Pertahankan pilihan pengguna selama proses berlangsung.

---

# 11. Integrasi Text-to-Speech

Paket `flutter_tts: ^4.2.0` sudah ada menurut audit, tetapi belum digunakan.

## 11.1 TTS Service

Buat wrapper `TtsService` agar kontrol suara tidak ditulis terpisah di setiap layar.

Fungsi minimum:
- `initialize()`
- `speak(String text)`
- `stop()`
- `setLanguage('id-ID')`
- `setSpeechRate(double rate)`
- `dispose()` bila diperlukan oleh implementasi

Gunakan bahasa Indonesia jika tersedia di mesin suara perangkat. Ketersediaan voice `id-ID` harus diperiksa saat runtime karena tergantung mesin TTS perangkat.

## 11.2 Perilaku UI

- Tombol audio pada layar pilihan membacakan pertanyaan atau teks bantuan.
- Tombol audio pada rangkuman membacakan `audioScript` atau gabungan teks hasil yang telah ditentukan.
- Pengguna bisa menghentikan audio.
- Pindah halaman atau menutup layar harus menghentikan pembacaan yang sedang berjalan.
- Hindari dua request speak berjalan bersamaan.
- Jika TTS tidak tersedia, teks tetap dapat dibaca secara manual.

TTS tidak memerlukan panggilan Gemini tambahan. Gunakan teks yang sudah diterima dari backend.

---

# 12. Penyimpanan Riwayat Lokal

Audit menyatakan `shared_preferences` sudah tersedia tetapi belum digunakan, dan list riwayat masih berada di memori.

## 12.1 Perilaku MVP

- Refleksi tidak disimpan otomatis kecuali pengguna mengaktifkan pengaturan simpan otomatis dengan persetujuan yang jelas.
- Tombol **Simpan Refleksi** menyimpan record ke perangkat.
- Riwayat menampilkan record yang benar-benar tersimpan, bukan data contoh.
- Tombol **Hapus Semua Riwayat** menghapus data yang tersimpan.
- Setelah restart, data tersimpan tetap tersedia.
- Logout tidak boleh menghapus data lokal secara diam-diam tanpa penjelasan. Tentukan perilaku yang konsisten dan beri tahu pengguna.
- Jika pengguna memakai perangkat bersama, tampilkan peringatan bahwa penyimpanan lokal berada pada perangkat itu.

## 12.2 Batasan SharedPreferences

`SharedPreferences` sesuai untuk pengaturan sederhana dan MVP berukuran kecil. Karena refleksi adalah data pribadi, evaluasi kebutuhan enkripsi lokal sebelum rilis publik. Jika perlu, gunakan penyimpanan lokal terenkripsi yang sesuai. Jangan menyimpan token atau secret dalam record riwayat.

## 12.3 Privasi

- Kirim ke Gemini hanya pilihan yang diperlukan untuk menghasilkan respons.
- Jangan mengirim nama, email, atau UID kecuali ada kebutuhan teknis yang jelas.
- Jangan menulis isi refleksi ke `console.log`, `Logger`, `debugPrint`, atau log analitik.
- Sediakan tindakan hapus riwayat yang benar-benar menghapus penyimpanan lokal.
- Jelaskan bahwa request ke Gemini diproses oleh layanan AI pihak ketiga sesuai ketentuan layanan yang berlaku.

---

# 13. Pusat Bantuan Aman dan Penanganan Risiko

## 13.1 Prinsip

Ruang Cerita bukan layanan darurat. Aplikasi harus menyediakan akses langsung ke bantuan manusia tanpa bergantung pada backend atau Gemini.

## 13.2 Ketika pengguna mengindikasikan risiko

- Jangan melanjutkan alur seolah-olah ini refleksi biasa.
- Tampilkan Pusat Bantuan Aman.
- Sampaikan pesan empatik dan langsung.
- Sarankan pengguna menghubungi layanan darurat setempat atau orang tepercaya yang dapat mendampingi.
- Jika bahaya segera terjadi, arahkan ke bantuan langsung.
- Jangan mengandalkan output generatif sebagai satu-satunya keputusan keselamatan.
- Jalur bantuan harus dapat dibuka offline.

## 13.3 Kontak bantuan

Audit menyebut tombol telepon 119 dan kontak lain, namun validitas, cakupan, dan ketersediaan nomor harus diverifikasi secara manual melalui sumber resmi sebelum rilis. Tombol WhatsApp saat ini menggunakan `https://wa.me/` tanpa nomor tujuan dan belum berfungsi. Jangan mengarang nomor. Tahan tombol tersebut atau tampilkan hanya setelah nomor resmi diverifikasi.

Perbaikan Android yang disebut audit:
- Tambahkan izin `android.permission.INTERNET` ke `android/app/src/main/AndroidManifest.xml` sebelum melakukan request API pada APK.
- Verifikasi konfigurasi `queries` untuk skema `tel:` agar `canLaunchUrl` dapat bekerja pada versi Android yang ditargetkan.
- Uji tombol panggilan pada perangkat nyata dan build release.

---

# 14. Keamanan

## 14.1 Autentikasi request

- Semua action privat wajib memerlukan Firebase ID token.
- Flutter mengambil token melalui Firebase SDK.
- Apps Script memvalidasi token di backend sebelum memproses data.
- Jangan menerima UID yang dikirim klien sebagai bukti identitas.
- Jangan menerima token kosong, invalid, atau kedaluwarsa.
- Token tidak boleh disimpan dalam riwayat atau log.

## 14.2 API key Gemini

- Simpan `GEMINI_API_KEY` di Script Properties.
- Jangan kirim key ke Flutter.
- Jangan mengembalikan key dalam respons error.
- Jangan mencetak key di execution log.
- Batasi akses editor Apps Script hanya kepada pemilik/developer yang perlu.

## 14.3 Validasi input

Backend harus:
- Memeriksa action yang diizinkan.
- Memeriksa ID perasaan, situasi, durasi, dan tujuan dukungan terhadap allowlist.
- Membatasi ukuran request dan jumlah jawaban.
- Menolak struktur JSON yang salah.
- Mengabaikan atau menolak properti yang tidak dikenal sesuai kebijakan implementasi.
- Tidak memperlakukan label yang dikirim klien sebagai data otoritatif.

## 14.4 Abuse prevention

- Terapkan pembatasan request dasar per pengguna.
- Jangan mengandalkan pembatasan lokal Flutter saja.
- Jangan retry otomatis tanpa batas.
- Pantau kuota dan error Apps Script serta Gemini tanpa merekam isi refleksi.
- Untuk produksi, evaluasi proteksi abuse yang lebih kuat karena endpoint Web App dapat diakses dari internet.

## 14.5 Keterbatasan Apps Script

Apps Script memiliki kuota layanan dan batas waktu eksekusi. Request Gemini yang terlalu lama dapat gagal. Uji latensi, batas eksekusi, dan volume penggunaan sebelum rilis. Jika aplikasi tumbuh, evaluasi backend yang lebih sesuai untuk request berlatensi panjang.

---

# 15. Penanganan Error

| Kondisi | Perilaku aplikasi |
|---|---|
| Tidak ada internet | Pertahankan pilihan dan tampilkan pesan offline |
| Firebase token tidak valid | Minta pengguna masuk kembali |
| Request timeout | Tampilkan coba lagi; jangan langsung mengirim berulang kali |
| Redirect gagal | Tampilkan gangguan koneksi server dan catat error teknis tanpa data pribadi |
| JSON tidak valid | Jangan render hasil parsial sebagai respons AI |
| Gemini gagal | Tampilkan pesan kegagalan dan tawarkan latihan lokal/Pusat Bantuan |
| Rate limit | Minta pengguna menunggu sebelum mencoba kembali |
| Respons AI kosong | Tampilkan error generik dan jangan menyimpan record kosong |
| Indikasi bahaya | Buka Pusat Bantuan Aman dan jangan lanjutkan generasi refleksi biasa |

Error teknis boleh dicatat dalam log tanpa token, email, isi refleksi, atau informasi sensitif.

---

# 16. Implementasi di Android

Berdasarkan audit, `android/app/src/main/AndroidManifest.xml` belum mendeklarasikan izin internet.

Sebelum uji API:
1. Tambahkan `android.permission.INTERNET` pada manifest yang sesuai.
2. Verifikasi konfigurasi `queries` untuk `tel:` jika memakai `canLaunchUrl`.
3. Pastikan URL Apps Script menggunakan HTTPS.
4. Uji redirect GET dan POST.
5. Uji pada debug build dan release APK.
6. Pastikan tidak ada API key Gemini dalam bundle aplikasi.

Jangan mengubah `google-services.json` atau `firebase_options.dart` yang sudah bekerja kecuali ada masalah Firebase yang dapat dibuktikan.

---

# 17. Daftar File dan Perubahan yang Diperlukan

Daftar ini mengikuti audit. Developer harus memeriksa file aktual sebelum menerapkan perubahan.

## 17.1 File yang kemungkinan ditambah

- `lib/models/session_request.dart`
- `lib/models/session_answer.dart`
- `lib/models/ai_reflection_response.dart`
- `lib/models/reflection_record.dart`
- `lib/services/api_service.dart`
- `lib/services/tts_service.dart`
- `lib/services/storage_service.dart`

## 17.2 File yang kemungkinan diubah

### `pubspec.yaml`
- Tambahkan dependency `http` jika dipilih.
- Jangan menghapus package yang sudah digunakan.
- Jalankan `flutter pub get` dan pastikan tidak ada konflik versi.

### `lib/services/auth_service.dart`
- Tambahkan method untuk memperoleh Firebase ID token.
- Pertahankan method login, registrasi, Google Sign-In, logout, dan pemetaan error yang sudah berfungsi.

### `lib/screens/pilih_perasaan_screen.dart`
- Kirim ID internal, bukan label UI.
- Hubungkan tombol audio ke `TtsService`.

### `lib/screens/pilih_situasi_screen.dart`
- Standarkan ID situasi.
- Hubungkan tombol audio ke `TtsService`.

### `lib/screens/pertanyaan_adaptif_screen.dart`
- Bentuk model sesi secara konsisten.
- Pertahankan pilihan durasi.
- Hubungkan audio pertanyaan ke TTS.
- Jika pertanyaan tetap statis pada MVP, jangan menambah request backend yang tidak diperlukan.

### `lib/screens/rangkuman_hangat_ai_screen.dart`
- Ganti teks refleksi hardcoded dengan hasil API.
- Tambahkan loading, error, retry manual, dan pencegahan request ganda.
- Tampilkan rangkuman dan langkah praktis dari response.
- Hubungkan tombol audio ke TTS.
- Implementasikan penyimpanan saat pengguna memilih menyimpan.

### `lib/screens/sesi_selesai_screen.dart`
- Simpan evaluasi akhir bersama record jika pengguna menyetujui.
- Pastikan tombol simpan benar-benar menjalankan penyimpanan.

### `lib/screens/riwayat_privasi_screen.dart`
- Baca record dari penyimpanan lokal.
- Implementasikan hapus satu record dan hapus semua record.
- Persistensikan pengaturan privasi yang ditampilkan.

### `lib/screens/pusat_bantuan_aman_screen.dart`
- Verifikasi nomor dan link melalui sumber resmi.
- Perbaiki tombol WhatsApp hanya jika tujuan valid telah disediakan.
- Pastikan bantuan tetap dapat dibuka offline.

### `android/app/src/main/AndroidManifest.xml`
- Tambahkan izin internet.
- Verifikasi intent query untuk telepon sesuai kebutuhan Android target.

Jangan mengubah seluruh file sekaligus. Integrasikan per tahap dan jalankan pengujian setelah tiap tahap.

---

# 18. Roadmap MVP

## Tahap 1: Persiapan dan kontrak
- [ ] Pastikan kode Google Apps Script yang aktif.
- [ ] Cocokkan action, body request, dan response.
- [ ] Pastikan Script Properties tersedia.
- [ ] Uji POST nyata tanpa data sensitif.
- [ ] Tetapkan allowlist ID pilihan.

**Selesai jika:** Flutter dan backend sepakat menggunakan satu kontrak JSON yang terdokumentasi.

## Tahap 2: Fondasi API
- [ ] Tambahkan izin internet Android.
- [ ] Tambahkan `getIdToken()` di AuthService.
- [ ] Buat model request dan response.
- [ ] Buat `ApiService`.
- [ ] Uji health check dan validasi error.
- [ ] Uji redirect POST.

**Selesai jika:** aplikasi bisa mengirim request autentikasi dan membaca JSON tanpa mengubah alur login.

## Tahap 3: Integrasi refleksi AI
- [ ] Standarkan ID pilihan perasaan dan situasi.
- [ ] Bangun model sesi.
- [ ] Hubungkan layar rangkuman ke API.
- [ ] Tampilkan loading dan error.
- [ ] Validasi output sebelum ditampilkan.
- [ ] Uji response kosong, timeout, dan error Gemini.

**Selesai jika:** respons backend menggantikan teks mock dengan aman.

## Tahap 4: TTS
- [ ] Buat `TtsService`.
- [ ] Atur bahasa `id-ID` jika tersedia.
- [ ] Hubungkan tombol audio pada layar pertanyaan.
- [ ] Hubungkan tombol audio pada rangkuman.
- [ ] Hentikan suara saat berpindah halaman.
- [ ] Uji perangkat yang tidak memiliki voice Indonesia.

**Selesai jika:** semua kontrol audio menjalankan fungsi nyata dan tidak tumpang tindih.

## Tahap 5: Riwayat lokal
- [ ] Buat `StorageService`.
- [ ] Simpan hanya setelah persetujuan pengguna.
- [ ] Tampilkan data tersimpan pada halaman riwayat.
- [ ] Implementasikan hapus satu/hapus semua.
- [ ] Persistensikan pengaturan privasi.
- [ ] Evaluasi perlindungan penyimpanan data sensitif.

**Selesai jika:** record tetap tersedia setelah aplikasi ditutup dan terhapus setelah pengguna menghapusnya.

## Tahap 6: Keselamatan dan rilis
- [ ] Verifikasi kontak bantuan.
- [ ] Uji jalur risiko tanpa koneksi internet.
- [ ] Uji token invalid dan token kedaluwarsa.
- [ ] Uji request berulang dan rate limit.
- [ ] Uji debug dan release APK.
- [ ] Periksa tidak ada secret atau isi refleksi di log.
- [ ] Uji dengan pengguna terbatas sebelum rilis publik.

**Selesai jika:** fungsi utama, error, privasi, dan jalur bantuan lolos pengujian.

---

# 19. Kriteria Penerimaan

## Autentikasi
- Login email/password dan Google tetap berfungsi.
- Pengguna yang belum login tidak dapat menjalankan action privat.
- Token invalid ditolak backend.
- Tidak ada password yang dikirim ke Apps Script.

## API
- Request menggunakan HTTPS dan JSON.
- ID perasaan, situasi, dan durasi sesuai allowlist.
- Redirect POST diuji dengan payload tetap utuh.
- UI menampilkan loading dan mencegah submit ganda.
- Timeout dan error tidak menyebabkan aplikasi crash.
- Respons AI tidak dirender jika struktur wajib tidak valid.

## AI
- Respons tidak mengklaim diagnosis.
- Tidak ada persentase klinis atau klaim akurasi yang tidak tervalidasi.
- Respons memakai bahasa Indonesia yang suportif.
- Saran praktis aman, sederhana, dan tidak memaksa.
- AI tidak digunakan sebagai satu-satunya jalur penanganan krisis.

## TTS
- Audio benar-benar diputar.
- Pengguna dapat menghentikan audio.
- Audio berhenti saat layar ditutup atau sesi berganti.
- Aplikasi tetap dapat digunakan tanpa TTS.

## Riwayat
- Tidak menyimpan refleksi otomatis tanpa pengaturan/persetujuan yang jelas.
- Record yang disimpan tetap tersedia setelah restart.
- Hapus semua benar-benar menghapus data tersimpan.
- Tidak menyimpan ID token atau API key dalam record.

## Keselamatan
- Pusat Bantuan Aman dapat dibuka dari UI tanpa API.
- Kontak telah diverifikasi sebelum rilis.
- Jalur bantuan tidak bergantung pada keberhasilan Gemini.

---

# 20. Risiko dan Keputusan Terbuka

| Risiko/pertanyaan | Tindakan |
|---|---|
| Action deployment GAS belum diverifikasi | Cocokkan kode deployment dengan kontrak PRD |
| Format response GAS bisa berbeda | Tetapkan satu schema dan uji contract test |
| POST redirect dapat berbeda dari GET | Uji POST nyata dari Flutter |
| Batas waktu Apps Script | Ukur latensi Gemini dan uji timeout |
| ID UI belum konsisten | Gunakan ID internal pada seluruh alur |
| TTS Indonesia bergantung perangkat | Deteksi ketersediaan bahasa dan sediakan fallback teks |
| Riwayat berisi data pribadi | Simpan hanya atas pilihan pengguna dan evaluasi enkripsi lokal |
| Nomor bantuan belum diverifikasi | Periksa sumber resmi sebelum rilis |
| URL WhatsApp kosong | Jangan tampilkan sebagai tombol aktif sampai nomor resmi tersedia |
| API key bocor | Simpan di Script Properties, jangan di Flutter |
| Penyalahgunaan endpoint publik | Validasi token, allowlist, pembatasan request, dan pemantauan kuota |

---

# 21. Instruksi untuk Claude Code pada Tahap Implementasi

Gunakan PRD ini sebagai acuan, tetapi lakukan implementasi bertahap.

1. Jangan merombak autentikasi yang sudah bekerja.
2. Jangan mengganti desain Stitch atau mengubah palet warna tanpa permintaan.
3. Periksa kontrak Apps Script yang aktif sebelum menulis `ApiService`.
4. Jika kontrak backend tidak sesuai PRD, laporkan perbedaannya dan usulkan penyelarasan sebelum mengubah banyak file.
5. Implementasikan fondasi API dan model data terlebih dahulu.
6. Hubungkan layar rangkuman setelah request/response lulus pengujian.
7. Implementasikan TTS dan riwayat sebagai tahap terpisah.
8. Jalankan analyzer dan tes yang relevan setelah tiap tahap.
9. Jangan menampilkan atau mencetak secret.
10. Jangan mengarang respons AI ketika request gagal. Gunakan error state yang jelas.
11. Jangan menganggap mock UI sebagai fitur yang sudah berfungsi.
12. Laporkan file yang diubah dan hasil pengujian setelah setiap tahap.

---

# 22. Referensi Teknis

Dokumentasi yang perlu dirujuk developer:
- Google Apps Script Web Apps: https://developers.google.com/apps-script/guides/web
- Google Apps Script Content Service: https://developers.google.com/apps-script/guides/content
- Gemini API: https://ai.google.dev/gemini-api/docs
- Firebase Authentication: https://firebase.google.com/docs/auth
- Flutter TTS package: https://pub.dev/packages/flutter_tts
- Shared Preferences package: https://pub.dev/packages/shared_preferences
- Flutter HTTP package: https://pub.dev/packages/http

**Akhir dokumen.**
"""

# Use pypandoc as required for Markdown output, writing a standalone Markdown artifact.
pypandoc.convert_text(md, to="md", format="md", outputfile=out_path, extra_args=["--standalone"])
print(f"PRD berhasil dibuat: {out_path}")
