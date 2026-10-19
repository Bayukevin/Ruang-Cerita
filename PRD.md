# PRD.md --- Ruang Cerita

## Product Requirements Document untuk Aplikasi Pendamping Kesehatan Mental Berbasis AI

**Nama produk:** Ruang Cerita\
**Jenis dokumen:** Product Requirements Document (PRD)\
**Versi:** 1.0\
**Status:** Draft untuk perencanaan dan implementasi\
**Platform target:** Android terlebih dahulu, dengan arsitektur yang
memungkinkan dukungan iOS\
**Frontend:** Flutter\
**Backend dan database:** Firebase serta backend tepercaya untuk
integrasi AI\
**AI percakapan:** Gemini API melalui backend\
**Text-to-speech awal:** `flutter_tts` menggunakan mesin TTS perangkat\
**Sumber desain utama:** Desain Google Stitch yang telah ditautkan
melalui MCP pada workspace/proyek pengguna

------------------------------------------------------------------------

# 1. Instruksi Utama untuk Developer dan Coding Agent

## 1.1 Instruksi wajib: ikuti desain Stitch yang sudah ditautkan melalui MCP

Sebelum menulis atau mengubah kode UI, **periksa desain Ruang Cerita
yang sudah ditautkan melalui MCP Stitch pada workspace/proyek
pengguna**. Desain Stitch tersebut merupakan *source of truth* untuk
tampilan visual dan alur layar.

Jangan membuat ulang desain berdasarkan asumsi sendiri, jangan mengganti
palet warna, jangan menyederhanakan komponen tanpa alasan, dan jangan
membuat UI generik yang hanya terinspirasi dari dokumen ini apabila
desain Stitch yang sebenarnya tersedia.

Urutan kerja wajib:

1.  Temukan dan periksa proyek/desain Ruang Cerita yang sudah ditautkan
    melalui MCP Stitch.
2.  Periksa seluruh layar, komponen, varian, spacing, typography, warna,
    ikon, navigasi, dan interaksi yang tersedia.
3.  Jika MCP mendukung pembacaan design context, ambil design context
    dan gunakan sebagai referensi implementasi.
4.  Jika tersedia beberapa versi desain, identifikasi versi terbaru atau
    minta konfirmasi sebelum memilih versi yang berpotensi berbeda.
5.  Catat pemetaan layar Stitch ke layar Flutter.
6.  Implementasikan UI sesuai desain Stitch, termasuk keadaan normal,
    selected, disabled, loading, error, audio playing, empty state, dan
    safety state jika desainnya tersedia.
7.  Jika ada detail yang tidak tersedia di Stitch, gunakan Design.md dan
    PRD ini sebagai panduan sekunder. Pilih solusi yang paling konsisten
    dengan sistem desain Stitch.
8.  Jangan mengarang bahwa desain sudah berhasil dibaca jika MCP tidak
    dapat diakses. Laporkan hambatan secara spesifik dan minta akses
    atau referensi desain yang diperlukan.
9.  Jangan mengubah desain Stitch secara otomatis. Jika perubahan visual
    diperlukan, usulkan perubahan terlebih dahulu atau lakukan hanya
    jika pengguna secara eksplisit memintanya.
10. Setelah implementasi, bandingkan setiap layar dengan desain Stitch
    dan perbaiki perbedaan layout, warna, ukuran, radius, tipografi, dan
    perilaku.

**Prioritas sumber kebenaran:**

1.  Desain Stitch yang sudah ditautkan melalui MCP untuk keputusan
    visual dan layout.
2.  PRD ini untuk persyaratan produk, perilaku, arsitektur, keselamatan,
    dan kriteria penerimaan.
3.  `Design.md` untuk arahan visual tambahan dan master prompt.
4.  Keputusan teknis yang terdokumentasi untuk hal yang belum ditentukan
    oleh ketiga sumber di atas.

Jika terjadi konflik antara desain Stitch dan persyaratan
keselamatan/aksesibilitas, keselamatan dan aksesibilitas harus dipenuhi
tanpa mengubah identitas visual secara tidak perlu. Dokumentasikan
konflik dan penyelesaiannya.

## 1.2 Instruksi untuk coding agent

-   Periksa struktur repository, file konfigurasi, versi Flutter/Dart,
    dan integrasi Firebase yang sudah ada sebelum melakukan perubahan.
-   Pertahankan fitur yang sudah berjalan. Jangan menghapus atau
    mengganti fungsi yang tidak terkait.
-   Gunakan implementasi modular, tipe data yang jelas, dan pola state
    management yang konsisten dengan proyek.
-   Jangan menaruh API key Gemini, secret, atau kredensial server di
    source code Flutter.
-   Jangan membuat klaim bahwa aplikasi memberikan diagnosis psikologis.
-   Jangan membuat skor klinis, probabilitas gangguan, atau hasil
    skrining yang tidak memiliki dasar tervalidasi.
-   Semua alur berisiko tinggi harus memakai aturan keselamatan yang
    dapat diuji, bukan hanya prompt AI.
-   Jangan menyimpan isi percakapan sensitif secara permanen secara
    default.
-   Semua operasi Firebase harus mengikuti prinsip least privilege dan
    diuji dengan Firebase Emulator Suite jika memungkinkan.
-   Buat tes unit, widget, integrasi, security rules, serta tes alur
    keselamatan.
-   Jangan menganggap pekerjaan selesai hanya karena aplikasi berhasil
    dikompilasi. Lakukan pengujian fungsi dan visual.

------------------------------------------------------------------------

# 2. Ringkasan Produk

Ruang Cerita adalah aplikasi pendamping kesehatan mental berbasis AI
yang membantu pengguna mengenali perasaan, merefleksikan situasi, dan
mencoba langkah dukungan diri yang sederhana melalui sesi terpandu.

Pengalaman inti menggunakan **pertanyaan bertahap dengan pilihan jawaban
yang dapat dipilih melalui satu sentuhan**. Pertanyaan dibacakan melalui
text-to-speech (TTS), sementara pengguna dapat melihat teks, memutar
ulang audio, menjeda suara, atau melewati audio. Pengguna tidak wajib
mengetik untuk menyelesaikan sesi utama.

Setelah jawaban dikumpulkan, backend menyusun konteks yang terstruktur
dan mengirimkannya ke Gemini API. AI menghasilkan respons suportif
berdasarkan pilihan pengguna. Respons divalidasi oleh backend sebelum
ditampilkan dan dibacakan menggunakan TTS.

Ruang Cerita bukan psikolog manusia, bukan layanan terapi profesional,
bukan alat diagnosis gangguan mental, dan bukan layanan darurat.
Aplikasi harus transparan bahwa pengguna berinteraksi dengan AI.

## 2.1 Pernyataan nilai produk

"Ruang Cerita memberi ruang bagi pengguna untuk mengenali perasaan dan
menentukan satu langkah kecil berikutnya, tanpa harus menuliskan cerita
panjang."

## 2.2 Masalah pengguna

-   Sebagian pengguna kesulitan memulai cerita tentang perasaan mereka.
-   Mengetik keluhan panjang terasa melelahkan atau tidak nyaman.
-   Pengguna membutuhkan alur yang terstruktur dan tidak menghakimi.
-   Pengguna mungkin lebih nyaman mendengar pertanyaan daripada membaca
    paragraf panjang.
-   Pengguna membutuhkan saran sederhana, refleksi, dan pilihan langkah
    selanjutnya tanpa aplikasi mengklaim menggantikan tenaga
    profesional.

## 2.3 Solusi

-   Pilihan perasaan dan situasi berbentuk kartu.
-   Pertanyaan adaptif berdasarkan jawaban sebelumnya.
-   Audio pertanyaan dan respons AI.
-   Ringkasan sesi yang hanya menggunakan informasi yang dipilih
    pengguna.
-   Saran sederhana dan latihan dukungan diri.
-   Riwayat sesi yang bersifat opsional.
-   Perlindungan privasi, batas kemampuan AI, dan jalur bantuan manusia
    untuk situasi berisiko.

------------------------------------------------------------------------

# 3. Sasaran Produk dan Non-Sasaran

## 3.1 Sasaran utama

1.  Membuat pengguna dapat menyelesaikan sesi awal tanpa mengetik teks
    bebas.
2.  Menyediakan pengalaman yang hangat, jelas, mudah digunakan, dan
    konsisten dengan desain Stitch.
3.  Menghasilkan respons AI yang relevan dengan pilihan pengguna, tidak
    menghakimi, dan tidak mengklaim diagnosis.
4.  Memungkinkan pengguna mendengarkan pertanyaan dan respons dalam
    bahasa Indonesia.
5.  Menggunakan Firebase untuk autentikasi, database, dan layanan
    pendukung.
6.  Menjaga secret AI dan kredensial pihak ketiga hanya di lingkungan
    backend yang tepercaya.
7.  Menyediakan penanganan keselamatan dan kegagalan layanan yang dapat
    diuji.
8.  Memberi pengguna kendali atas riwayat, persetujuan, dan penghapusan
    data.
9.  Menyediakan arsitektur yang dapat dikembangkan tanpa menulis ulang
    aplikasi secara menyeluruh.

## 3.2 Non-sasaran MVP

-   Mendiagnosis depresi, gangguan kecemasan, bipolar, PTSD, atau
    gangguan mental lain.
-   Menggantikan psikolog, psikiater, konselor, atau layanan darurat.
-   Melakukan terapi klinis otomatis.
-   Menentukan risiko bunuh diri hanya berdasarkan satu skor AI.
-   Mengklaim bahwa latihan atau saran tertentu menyembuhkan gangguan.
-   Melakukan panggilan suara real-time dua arah atau percakapan telepon
    AI.
-   Menggunakan pengenalan suara atau speech-to-text sebagai fitur
    utama.
-   Menggunakan AI untuk mengubah aturan keselamatan secara otomatis.
-   Menjual data percakapan atau menggunakan data sensitif untuk iklan.
-   Membangun dashboard profesional untuk psikolog pada MVP.
-   Menyediakan diagnosis atau persentase kemungkinan gangguan mental.

------------------------------------------------------------------------

# 4. Target Pengguna dan Prinsip Penggunaan

## 4.1 Target pengguna

Target awal adalah masyarakat umum yang ingin melakukan refleksi emosi
sehari-hari dan mencari dukungan umum.

Usia minimum, alur pengguna anak, persetujuan wali, dan cakupan
penggunaan harus ditetapkan sebelum peluncuran publik. Jika produk
dibuka untuk anak atau remaja, desain keselamatan, privasi, bahasa, dan
mekanisme dukungan harus ditinjau secara khusus oleh profesional yang
kompeten.

## 4.2 Prinsip interaksi

-   Pengguna tidak perlu mengetik untuk menyelesaikan alur utama.
-   Setiap pertanyaan harus ringkas, natural, dan mudah dipahami saat
    dibacakan.
-   Pengguna dapat memilih "Belum tahu", "Lewati", atau "Tidak ingin
    menjawab" jika sesuai dengan logika pertanyaan.
-   Jangan memaksa pengguna membagikan detail sensitif.
-   Pengguna dapat kembali dan mengganti jawaban jika alur mengizinkan.
-   Aplikasi harus menghindari streak, penalti, atau gamifikasi yang
    mempermalukan pengguna.
-   Jangan mengasumsikan penyebab perasaan berdasarkan jenis kelamin,
    agama, status hubungan, pekerjaan, atau latar belakang.
-   AI tidak boleh berpura-pura memiliki emosi, pengalaman pribadi, atau
    identitas sebagai manusia.

------------------------------------------------------------------------

# 5. Platform dan Teknologi

## 5.1 Frontend

-   Flutter dan Dart.
-   Android sebagai platform rilis awal.
-   Struktur proyek disiapkan agar mendukung iOS.
-   Desain responsif mengikuti desain Stitch.
-   Gunakan package TTS yang terpelihara dan kompatibel dengan versi
    Flutter proyek.
-   Gunakan state management yang konsisten, misalnya Riverpod, Bloc,
    atau pendekatan yang telah digunakan repository. Jangan menambahkan
    dua sistem state management tanpa kebutuhan jelas.

## 5.2 Firebase

Layanan yang direncanakan:

-   Firebase Authentication: email/password dan Google Sign-In.
-   Cloud Firestore: profil minimum, katalog sesi, jawaban dan riwayat
    opsional, pengaturan, metadata.
-   Firebase App Check: membantu mengurangi penyalahgunaan akses dari
    klien.
-   Firebase Crashlytics: laporan crash yang tidak memuat isi percakapan
    sensitif.
-   Firebase Analytics: opsional, hanya untuk event minimal yang tidak
    memuat teks kesehatan atau identitas sensitif.
-   Firebase Cloud Functions atau backend tepercaya terpisah untuk
    panggilan Gemini API, validasi respons, dan aturan keselamatan.
-   Firebase Cloud Storage: hanya jika diperlukan untuk aset/audio yang
    tidak bisa disimpan sebagai aset aplikasi. Jangan mengunggah rekaman
    suara pengguna pada MVP.

**Catatan biaya:** deployment Cloud Functions memerlukan paket Firebase
Blaze. Kuota tanpa biaya tidak berarti penggunaan bebas biaya. Atur
budget alerts, rate limits, dan pemantauan biaya sebelum membuka akses
publik.

## 5.3 AI

-   Gemini API digunakan melalui backend, bukan langsung dari Flutter.
-   Pilih model berdasarkan kualitas bahasa Indonesia, latensi, biaya,
    ketersediaan, dan kebijakan data yang sesuai.
-   Model harus dapat diganti melalui konfigurasi server tanpa merilis
    ulang aplikasi untuk setiap pergantian model.
-   Output harus mengikuti skema JSON yang ditentukan.
-   Backend memvalidasi output sebelum disimpan atau ditampilkan.
-   AI hanya memberi dukungan umum dan refleksi, bukan diagnosis atau
    terapi profesional.
-   Jika model gagal, gunakan respons fallback yang telah ditinjau.

## 5.4 Text-to-speech

MVP menggunakan `flutter_tts` atau integrasi TTS perangkat yang sesuai.

Persyaratan: - Memeriksa dukungan bahasa Indonesia dan suara yang
tersedia pada perangkat. - Menampilkan teks pertanyaan saat audio tidak
tersedia. - Memungkinkan replay, pause, stop, dan pengaturan kecepatan
bila didukung. - Menghentikan audio sebelumnya ketika audio baru
dimulai. - Tidak mewajibkan audio untuk menyelesaikan sesi. -
Mempertahankan teks yang dapat dibaca oleh screen reader. - Tidak
mengirim isi percakapan ke layanan TTS cloud pada MVP jika TTS perangkat
sudah memadai.

Jika kemudian ditambahkan penyedia TTS cloud, integrasi harus dilakukan
melalui backend dengan secret yang aman, batas biaya, penanganan
kegagalan, dan peninjauan privasi.

------------------------------------------------------------------------

# 6. Instruksi Desain dan Implementasi UI

## 6.1 Source of truth visual

Desain Stitch yang sudah ditautkan melalui MCP merupakan sumber utama
untuk seluruh keputusan visual.

Developer/coding agent wajib memeriksa desain tersebut sebelum membuat
UI. Jangan hanya membaca `Design.md` lalu membuat tampilan generik
apabila desain Stitch dapat diakses.

### Proses implementasi desain

1.  Buka proyek Stitch melalui MCP yang sudah tersedia pada workspace.
2.  Identifikasi layar dan versi desain yang disetujui.
3.  Ambil design context atau spesifikasi yang tersedia.
4.  Buat daftar layar, komponen, token warna, tipografi, radius,
    spacing, dan interaksi.
5.  Petakan komponen Stitch ke widget Flutter yang reusable.
6.  Implementasikan satu layar pada satu waktu.
7.  Bandingkan implementasi dengan referensi Stitch pada ukuran layar
    yang sama.
8.  Perbaiki perbedaan visual dan perilaku.
9.  Catat bagian yang tidak dapat direplikasi secara langsung dan alasan
    teknisnya.
10. Jangan mengubah desain sumber tanpa izin.

Jika MCP Stitch tidak tersedia atau desain tidak dapat dibaca, hentikan
asumsi visual dan minta akses atau file referensi. Gunakan `Design.md`
hanya sebagai panduan cadangan.

## 6.2 Arahan visual tambahan

Rujuk `Design.md`. Secara umum, desain memakai: - Background putih. -
Komponen dengan warna fun seperti ungu, teal, coral, kuning, biru, dan
pink. - Kartu dengan radius besar. - Tipografi yang mudah dibaca. -
Ruang kosong yang cukup. - Tombol besar dan nyaman disentuh. - Suara dan
teks yang tampil berdampingan. - Tampilan yang hangat, tidak seperti
rumah sakit, dan tidak kekanak-kanakan.

Namun, token final, ukuran, layout, dan komponen harus mengikuti desain
Stitch yang telah disetujui.

------------------------------------------------------------------------

# 7. Informasi Arsitektur dan Alur Data

## 7.1 Arsitektur logis

``` text
Flutter App
  ├── Authentication UI
  ├── Guided Session UI
  ├── Choice Components
  ├── TTS Playback Controller
  ├── Session State
  └── Firebase Client SDK
         ├── Firebase Authentication
         ├── Firestore (akses sesuai Security Rules)
         └── Backend HTTPS Endpoint
                ├── Request Validation
                ├── Authentication/Authorization
                ├── Safety Rules
                ├── Session Context Builder
                ├── Gemini API Client
                ├── Output Schema Validation
                ├── Response Safety Validation
                ├── Optional Result Persistence
                └── Audit/Operational Metrics
```

## 7.2 Prinsip arsitektur

-   Flutter tidak memuat Gemini API key.
-   Klien tidak dapat mengubah aturan keselamatan.
-   Backend memvalidasi Firebase ID token.
-   Setiap sesi mempunyai ID unik dan status yang jelas.
-   Jawaban hanya dapat ditambahkan ke sesi yang dimiliki pengguna dan
    masih aktif.
-   Respons AI tidak dipercaya secara otomatis; semua output harus
    divalidasi.
-   Riwayat tidak disimpan tanpa pengaturan atau persetujuan yang
    sesuai.
-   Jika AI API gagal, sesi harus menampilkan pesan yang jelas dan tidak
    mengarang hasil.
-   Pemeriksaan keselamatan tidak bergantung pada keberhasilan AI.
-   Hindari microservices berlebihan pada MVP. Satu backend modular
    sudah cukup.

------------------------------------------------------------------------

# 8. User Journey dan Screen Requirements

Daftar berikut menjelaskan perilaku yang harus tersedia. Detail visual
tetap mengikuti layar pada desain Stitch.

## 8.1 Screen A --- Welcome / Onboarding

### Tujuan

Memperkenalkan Ruang Cerita, menjelaskan bahwa layanan menggunakan AI,
dan membantu pengguna memulai dengan nyaman.

### Elemen

-   Wordmark Ruang Cerita.
-   Headline dan deskripsi singkat.
-   Tombol mulai.
-   Penjelasan singkat mengenai batas kemampuan AI.
-   Akses ke kebijakan privasi dan ketentuan penggunaan.

### Perilaku

-   Tombol mulai membuka beranda atau alur sesi sesuai keputusan
    navigasi desain.
-   Jangan meminta data kesehatan sebelum menjelaskan tujuan dan
    privasi.
-   Jangan menyebut AI sebagai psikolog sungguhan.
-   Pengguna dapat membaca informasi tentang cara kerja layanan.

### Acceptance criteria

-   Pengguna memahami bahwa aplikasi menggunakan AI.
-   Pengguna dapat memulai tanpa mengetik cerita.
-   Tautan privasi dapat dibuka.
-   Layout sesuai desain Stitch.

## 8.2 Screen B --- Authentication

### Tujuan

Menyediakan akun melalui email/password dan Google Sign-In.

### Pilihan

-   Daftar dengan email dan password.
-   Login dengan email dan password.
-   Login/daftar menggunakan akun Google.
-   Lupa password.
-   Verifikasi email bila kebijakan produk mengharuskannya.
-   Logout.
-   Penghapusan akun dan data melalui pengaturan.

### Perilaku

-   Gunakan Firebase Authentication.
-   Jangan menyimpan password dalam Firestore.
-   Tampilkan validasi email dan pesan kesalahan yang mudah dipahami.
-   Tangani email yang belum diverifikasi sesuai kebijakan.
-   Tangani pembatalan Google Sign-In tanpa menampilkan error fatal.
-   Tangani konflik kredensial jika email yang sama terdaftar melalui
    metode berbeda.
-   Jangan meminta akses Google yang tidak dibutuhkan.
-   Jangan mewajibkan login sebelum sesi pertama kecuali ada keputusan
    produk yang mengharuskan penyimpanan akun. Jika sesi tamu didukung,
    data tamu harus ditangani secara eksplisit.

### Acceptance criteria

-   Pengguna dapat mendaftar dengan email/password.
-   Pengguna dapat login dan logout.
-   Pengguna dapat menggunakan Google Sign-In.
-   Pengguna dapat meminta reset password.
-   Error Firebase dipetakan ke pesan yang aman dan jelas.
-   Tidak ada password atau token sensitif di log.

## 8.3 Screen C --- Home

### Tujuan

Menjadi pintu masuk yang tenang untuk sesi baru dan fitur refleksi.

### Elemen

-   Sapaan yang netral.
-   Tombol sesi baru.
-   Quick mood check-in.
-   Akses ke latihan singkat.
-   Akses riwayat jika diaktifkan.
-   Navigasi sesuai desain Stitch.

### Perilaku

-   Tombol sesi baru membuat sesi baru atau memulai alur sesi.
-   Riwayat hanya muncul sesuai status fitur dan pengaturan pengguna.
-   Jangan menampilkan ringkasan emosional sensitif pada notifikasi.
-   Tidak ada klaim bahwa aplikasi mengetahui perasaan pengguna tanpa
    input.

## 8.4 Screen D --- Choose Feeling

### Tujuan

Membiarkan pengguna memilih perasaan dengan satu sentuhan.

### Pilihan awal yang dapat dikonfigurasi

-   Cemas.
-   Sedih.
-   Marah.
-   Lelah.
-   Kesepian.
-   Bingung.
-   Baik-baik saja.
-   Belum tahu.

### Perilaku

-   Pilihan tunggal untuk pertanyaan ini kecuali definisi klinis/produk
    menetapkan sebaliknya.
-   Selected state harus terlihat dengan border, warna, dan/atau ikon.
-   Tombol lanjut aktif setelah jawaban valid atau opsi "Belum tahu"
    dipilih.
-   Audio pertanyaan bisa diputar ulang.
-   Pilihan tidak boleh mengandung label yang menghakimi.

## 8.5 Screen E --- Choose Situation

### Tujuan

Memahami konteks secara umum tanpa memaksa detail pribadi.

### Pilihan awal

-   Keluarga.
-   Pertemanan.
-   Sekolah atau pekerjaan.
-   Hubungan.
-   Diriku sendiri.
-   Hal lain.
-   Belum tahu.
-   Tidak ingin menjawab (bila sesuai).

### Perilaku

-   Pertanyaan berikutnya menyesuaikan pilihan.
-   Jangan menyimpulkan bahwa satu konteks merupakan penyebab pasti.
-   Pengguna dapat kembali dan mengubah pilihan jika sesi masih aktif.

## 8.6 Screen F --- Adaptive Questions

### Tujuan

Mengumpulkan informasi minimum yang dibutuhkan untuk memberi respons
yang relevan.

### Contoh kategori pertanyaan

-   Durasi perasaan.
-   Intensitas subjektif.
-   Dampak pada rutinitas.
-   Hal yang sudah dicoba.
-   Jenis dukungan yang diinginkan.
-   Apakah pengguna ingin didengarkan, dibantu memikirkan pilihan, atau
    mencoba latihan singkat.

### Perilaku

-   Satu pertanyaan per layar atau satu kartu fokus pada satu waktu.
-   Jumlah pertanyaan adaptif, tetapi memiliki batas yang ditetapkan.
-   Pertanyaan baru bergantung pada jawaban sebelumnya.
-   Sediakan "Belum yakin" dan "Lewati" bila memungkinkan.
-   Progress indicator harus masuk akal. Jangan menampilkan total
    langkah yang berubah-ubah tanpa penjelasan.
-   Pengguna dapat kembali jika perubahan jawaban tidak membatalkan
    aturan keselamatan.
-   Hindari mengulang pertanyaan yang sama.
-   Jangan membuat pertanyaan klinis atau pertanyaan sensitif baru
    secara bebas tanpa review.

### Acceptance criteria

-   Jawaban yang dipilih tersimpan pada sesi aktif.
-   Pertanyaan berikutnya sesuai dengan logika yang ditetapkan.
-   Pengguna dapat melanjutkan tanpa mengetik.
-   Jika backend gagal, aplikasi tidak mengarang pertanyaan berikutnya.

## 8.7 Screen G --- Safety Routing

### Tujuan

Menangani situasi yang membutuhkan bantuan manusia atau pertolongan
segera.

### Prinsip

-   Safety routing harus dirancang dan ditinjau bersama profesional
    kesehatan mental yang kompeten.
-   Jangan menjadikan LLM satu-satunya penentu tingkat risiko.
-   Jangan menyimpan skor risiko buatan tanpa validasi.
-   Jangan menganggap tidak adanya indikator berarti pengguna aman.
-   Jika terdeteksi risiko yang memerlukan respons khusus, hentikan sesi
    biasa dan tampilkan arahan yang sesuai.
-   Jangan menggunakan bahasa yang menyalahkan atau menakut-nakuti.
-   Sediakan jalur untuk menghubungi orang tepercaya atau layanan
    bantuan yang relevan.
-   Informasi darurat harus diverifikasi untuk wilayah target dan
    diperbarui bila diperlukan.
-   Jika AI tidak tersedia, safety flow tetap berjalan dengan konten
    statis yang telah ditinjau.

### Acceptance criteria

-   Seluruh skenario safety yang disetujui lulus tes.
-   AI tidak dapat menurunkan tingkat urgensi yang telah ditentukan
    aturan.
-   Safety content dapat tampil tanpa koneksi ke Gemini.
-   Tidak ada animasi atau gamifikasi yang meremehkan situasi krisis.

## 8.8 Screen H --- AI Supportive Response

### Tujuan

Memberikan respons suportif berdasarkan pilihan pengguna.

### Isi respons

-   Pengakuan terhadap jawaban pengguna tanpa berpura-pura mengetahui
    lebih dari yang disampaikan.
-   Ringkasan singkat berdasarkan pilihan yang benar-benar diberikan.
-   Satu atau dua saran praktis yang rendah risiko.
-   Pilihan latihan refleksi atau grounding jika sesuai.
-   Opsi melanjutkan sesi atau menyelesaikannya.
-   Teks yang dapat dibacakan TTS.
-   Penjelasan bahwa respons berasal dari AI.

### Larangan

-   Tidak memberikan diagnosis gangguan mental.
-   Tidak menyarankan menghentikan atau memulai obat.
-   Tidak menjanjikan hasil.
-   Tidak mengklaim menjadi psikolog atau terapis manusia.
-   Tidak menyuruh pengguna bergantung pada AI atau menjauh dari
    dukungan manusia.
-   Tidak membuat asumsi tentang pengalaman yang tidak pernah dipilih
    pengguna.
-   Tidak memberikan respons generik yang mengabaikan tanda bahaya.

### Acceptance criteria

-   Respons mengacu pada konteks sesi.
-   Respons mengikuti skema yang telah ditentukan.
-   Respons tidak berisi diagnosis atau klaim klinis yang tidak
    didukung.
-   Teks tetap tersedia jika audio gagal.
-   Pengguna dapat memutar, menjeda, menghentikan, dan membaca respons.

## 8.9 Screen I --- Guided Exercise

### Tujuan

Menawarkan aktivitas singkat seperti latihan napas atau grounding.

### Persyaratan

-   Pilihan durasi yang jelas.
-   Tombol mulai, jeda, lanjut, dan berhenti.
-   Instruksi teks dan audio.
-   Animasi dapat dinonaktifkan atau dikurangi.
-   Tidak menyatakan bahwa latihan menyembuhkan gangguan.
-   Jika pengguna merasa tidak nyaman, mereka dapat menghentikan latihan
    kapan saja.

## 8.10 Screen J --- Session Finished

### Tujuan

Mengakhiri sesi tanpa membuat pengguna merasa dinilai.

### Elemen

-   Pesan penutup.
-   Check-in opsional mengenai bagaimana perasaan pengguna setelah sesi.
-   Pilihan selesai.
-   Pilihan menyimpan refleksi jika fitur penyimpanan diaktifkan.
-   Akses ke latihan atau dukungan lanjutan.

### Perilaku

-   Tidak memaksa pengguna memberi penilaian.
-   Tidak menyimpan hasil tanpa aturan penyimpanan yang jelas.
-   Tidak menggunakan streak atau reward yang dapat menekan pengguna
    untuk terus menggunakan aplikasi.

## 8.11 Screen K --- History

### Tujuan

Menampilkan refleksi yang sengaja disimpan pengguna.

### Persyaratan

-   Riwayat bersifat opsional.
-   Tampilkan tanggal dan metadata minimum.
-   Pengguna dapat membuka dan menghapus entri.
-   Pengguna dapat menghapus seluruh riwayat.
-   Empty state menjelaskan bahwa belum ada refleksi tersimpan.
-   Jangan menampilkan konten sensitif dalam notifikasi atau widget
    sistem.
-   Jika akun dihapus, data terkait harus dihapus sesuai kebijakan dan
    kewajiban retensi.

## 8.12 Screen L --- Settings and Privacy

### Fitur

-   Pengaturan suara dan kecepatan bicara.
-   Autoplay pertanyaan: aktif/nonaktif.
-   Pilihan ukuran teks jika didukung.
-   Riwayat: aktif/nonaktif sesuai desain penyimpanan.
-   Penghapusan riwayat.
-   Penghapusan akun.
-   Logout.
-   Kebijakan privasi.
-   Ketentuan penggunaan.
-   Penjelasan batas AI.
-   Versi aplikasi dan kontak dukungan.

------------------------------------------------------------------------

# 9. Sistem Pertanyaan Bertahap

## 9.1 Desain data pertanyaan

Pertanyaan harus dikelola sebagai data terstruktur, bukan disusun
seluruhnya secara bebas oleh AI.

Setiap pertanyaan setidaknya memiliki: - `id` - `code` - `text_id` -
`spoken_text_id` atau referensi teks untuk TTS - `answer_type` -
`options` - `next_question_rules` - `skip_allowed` -
`safety_relevance` - `version` - `review_status`

## 9.2 Aturan alur

-   Jawaban pengguna menjadi input untuk memilih pertanyaan berikutnya.
-   Pertanyaan tidak relevan harus dilewati.
-   Jika jawaban tidak cukup, sistem dapat menawarkan opsi "Belum tahu"
    atau pertanyaan klarifikasi yang telah disetujui.
-   Jangan mengulang pertanyaan tanpa alasan.
-   Batasi panjang sesi.
-   Beri pengguna kendali untuk kembali, berhenti, atau menyelesaikan
    sesi.
-   Jika muncul indikator keselamatan, alur reguler dihentikan sesuai
    protokol.

## 9.3 Peran AI

AI boleh: - Menyusun respons suportif dari pilihan yang telah dipilih. -
Membuat ringkasan non-klinis. - Memilih di antara template respons yang
telah disetujui jika aturan mengizinkan. - Menyarankan latihan umum dari
katalog yang telah ditinjau.

AI tidak boleh: - Mengubah safety routing. - Membuat instrumen skrining
klinis baru. - Menetapkan diagnosis. - Menentukan risiko hanya dari
intuisi model. - Mengarang riwayat pengguna. - Mengubah persetujuan
penyimpanan data.

------------------------------------------------------------------------

# 10. Spesifikasi Gemini API

## 10.1 Prinsip integrasi

-   Semua panggilan Gemini dilakukan melalui backend.
-   API key disimpan sebagai secret server.
-   Flutter tidak pernah mengirim API key.
-   Backend menerapkan timeout, retry terbatas, rate limiting, dan
    pengendalian biaya.
-   Model dipilih melalui konfigurasi.
-   Respons mengikuti JSON schema yang ditentukan.
-   Input AI hanya mencakup konteks minimum yang diperlukan.
-   Jangan mengirim identitas langsung pengguna jika tidak dibutuhkan.
-   Kebijakan data provider harus ditinjau sebelum produksi.

## 10.2 Bentuk input internal

Contoh struktur internal untuk membangun konteks AI:

``` json
{
  "locale": "id-ID",
  "session_context": {
    "feeling": "anxious",
    "situation": "work_or_school",
    "duration": "several_days",
    "support_preference": "practical_steps"
  },
  "allowed_response_types": [
    "supportive_reflection",
    "general_coping_suggestion",
    "grounding_exercise",
    "professional_support_guidance"
  ],
  "safety_state": "normal"
}
```

Contoh di atas hanya data ilustratif. `safety_state` harus ditentukan
oleh sistem keselamatan yang telah dirancang dan diuji, bukan oleh teks
yang dihasilkan AI.

## 10.3 Bentuk output yang diharapkan

``` json
{
  "response_type": "supportive_reflection",
  "summary": "Kamu memilih bahwa pekerjaan atau sekolah sedang terasa membebani.",
  "supportive_text": "Terima kasih sudah mengenali apa yang sedang kamu rasakan. Kita bisa mulai dari satu hal kecil yang terasa paling mungkin dilakukan.",
  "suggestions": [
    {
      "title": "Pilih satu langkah kecil",
      "description": "Pilih satu tugas sederhana yang ingin kamu tangani lebih dahulu."
    }
  ],
  "follow_up_options": [
    {
      "label": "Coba latihan singkat",
      "action_code": "OPEN_GROUNDING"
    },
    {
      "label": "Lanjut bercerita",
      "action_code": "CONTINUE_SESSION"
    },
    {
      "label": "Selesaikan sesi",
      "action_code": "FINISH_SESSION"
    }
  ],
  "requires_human_support": false
}
```

Contoh ini adalah format ilustratif, bukan respons klinis yang telah
divalidasi.

## 10.4 Validasi output

Backend harus: - Memvalidasi JSON dan tipe setiap field. - Membatasi
panjang teks. - Menolak field yang tidak diizinkan. - Memastikan
`action_code` berasal dari allowlist. - Mencegah AI menambahkan URL atau
nomor bantuan yang tidak diverifikasi. - Memeriksa apakah respons
bertentangan dengan status keselamatan. - Menggunakan fallback yang
disetujui jika output tidak valid. - Tidak menyimpan raw prompt atau raw
response sensitif di log umum.

## 10.5 Prompting

Prompt harus menjelaskan: - AI adalah pendamping kesejahteraan mental,
bukan psikolog manusia. - Gunakan bahasa Indonesia yang hangat, jelas,
dan tidak menghakimi. - Jangan membuat diagnosis. - Jangan mengarang
informasi yang tidak diberikan. - Jangan memberikan saran medis atau
obat. - Hormati ketidakpastian dan batas pengetahuan. - Jangan memaksa
pengguna menceritakan hal sensitif. - Jangan menyatakan bahwa AI
memiliki emosi atau pengalaman manusia. - Ikuti status keselamatan yang
diberikan backend. - Kembalikan output sesuai schema.

Prompt bukan pengganti sistem keselamatan. Aturan keselamatan dan
validasi tetap harus diterapkan di backend.

------------------------------------------------------------------------

# 11. TTS dan Pengelolaan Audio

## 11.1 Perilaku TTS

-   Pertanyaan ditampilkan sebagai teks dan dapat dibacakan.
-   Autoplay bersifat opsional.
-   Audio sebelumnya dihentikan sebelum audio baru diputar.
-   Pengguna dapat play, pause, stop, dan replay.
-   Teks tetap tersedia jika TTS gagal.
-   Kecepatan bicara dapat diatur jika didukung.
-   Bahasa Indonesia harus diuji pada perangkat nyata.
-   Jangan mengunci navigasi hanya karena audio belum selesai.
-   Jangan memutar audio sensitif secara otomatis saat aplikasi kembali
    dari background tanpa konfirmasi yang sesuai.

## 11.2 State audio

Setiap komponen audio menangani status: - `idle` - `loading` -
`playing` - `paused` - `completed` - `error` - `unsupported`

UI harus memetakan setiap status ke visual dan pesan yang jelas sesuai
desain Stitch.

## 11.3 Pertanyaan statis dan respons dinamis

Pertanyaan tetap dapat menggunakan audio yang dibuat atau disiapkan
sebelumnya jika lisensi dan proses produksinya sesuai. Untuk MVP, TTS
perangkat mengurangi ketergantungan pada penyedia cloud.

Respons dinamis dibacakan menggunakan TTS perangkat. Jika pada masa
depan ditambahkan layanan TTS cloud, gunakan backend tepercaya dan
lakukan evaluasi biaya, latensi, kualitas bahasa, dan privasi.

------------------------------------------------------------------------

# 12. Firebase Authentication

## 12.1 Metode login

-   Email dan password.
-   Google Sign-In.
-   Logout.
-   Reset password.
-   Verifikasi email sesuai kebijakan produk.
-   Penghapusan akun.
-   Penanganan linking credential bila pengguna memakai lebih dari satu
    metode.

## 12.2 Email/password

-   Gunakan Firebase Authentication SDK.
-   Jangan membuat sistem password sendiri.
-   Jangan menyimpan password di Firestore.
-   Validasi format email di UI dan backend bila relevan.
-   Pesan error tidak boleh membocorkan informasi akun lebih dari yang
    diperlukan.
-   Tangani reset password dan email verification dengan pesan yang
    jelas.

## 12.3 Google Sign-In

-   Gunakan metode resmi yang sesuai untuk Flutter dan Firebase.
-   Konfigurasi Android SHA-1/SHA-256 jika diperlukan oleh setup.
-   Konfigurasi OAuth client dan package/bundle identifiers sesuai
    platform.
-   Tangani pembatalan login tanpa error fatal.
-   Tangani konflik akun dengan alur yang aman.
-   Minta hanya izin yang diperlukan untuk autentikasi.

## 12.4 Session dan token

-   Gunakan Firebase ID token untuk memanggil backend.
-   Backend memverifikasi token melalui mekanisme Firebase Admin SDK.
-   Jangan mempercayai `user_id` yang dikirim klien tanpa memverifikasi
    kepemilikan.
-   Jangan menaruh token di log.
-   Terapkan pemeriksaan autentikasi dan otorisasi pada endpoint privat.

------------------------------------------------------------------------

# 13. Struktur Firestore

Skema final dapat berubah setelah memeriksa repository, tetapi struktur
logis berikut disarankan.

## 13.1 `users/{uid}`

Field: - `displayName`: string opsional. - `email`: string dari Firebase
Auth jika dibutuhkan untuk tampilan. - `photoUrl`: string opsional. -
`createdAt`: timestamp. - `updatedAt`: timestamp. - `locale`: misalnya
`id-ID`. - `preferences`: map pengaturan non-sensitif. -
`historyEnabled`: boolean. - `accountStatus`: status akun.

Jangan menyimpan data yang sudah tersedia melalui Firebase Auth jika
tidak dibutuhkan. Jangan menaruh isi percakapan di profil pengguna.

## 13.2 `users/{uid}/preferences/{documentId}`

Field: - `ttsEnabled` - `autoPlayQuestions` - `speechRate` -
`textScale` - `reducedMotion` - `historyEnabled` - `updatedAt`

Validasi nilai dan batasi field yang dapat diubah pengguna.

## 13.3 `users/{uid}/sessions/{sessionId}`

Field: - `createdAt` - `updatedAt` - `status`: `in_progress`,
`completed`, `abandoned` - `flowVersion` - `savedByUser` - `summary`:
opsional, hanya jika pengguna memilih menyimpan dan kebijakan
mengizinkan. - `retentionUntil`: bila kebijakan retensi menggunakan
tanggal penghapusan. - `safetyRoutingApplied`: metadata minimum sesuai
kebutuhan audit, bukan pengganti log klinis.

Jangan menyimpan isi percakapan lengkap secara default. Pisahkan
penyimpanan sesi sementara dari refleksi yang sengaja disimpan.

## 13.4 `users/{uid}/sessions/{sessionId}/answers/{answerId}`

Field: - `questionCode` - `selectedOptionCode` - `createdAt` -
`questionVersion`

Simpan kode pilihan, bukan teks bebas, untuk alur utama. Hindari
menyalin seluruh prompt AI ke setiap dokumen.

## 13.5 `users/{uid}/saved_reflections/{reflectionId}`

Field: - `createdAt` - `title` - `summary` - `feelingCode` -
`userSavedAt` - `sourceSessionId` jika diperlukan dan diizinkan.

Dokumen ini hanya dibuat ketika pengguna memilih menyimpan refleksi.

## 13.6 Koleksi konfigurasi yang hanya dapat ditulis admin

Contoh: - `question_flows` - `question_definitions` -
`approved_response_templates` - `exercise_catalog` -
`support_resources` - `app_config`

Koleksi ini tidak boleh dapat ditulis pengguna biasa. Perubahan konten
yang memengaruhi keselamatan harus melalui review dan proses rilis yang
terdokumentasi.

## 13.7 Audit dan analytics

Gunakan sistem logging terpisah dengan akses terbatas. Catat event
teknis minimum seperti: - ID versi flow. - Versi prompt/model. - Status
permintaan. - Kode error. - Latensi. - Token usage jika tersedia dan
tidak memuat data pribadi.

Jangan mencatat isi percakapan, token autentikasi, secret API, atau data
sensitif dalam analytics standar.

------------------------------------------------------------------------

# 14. Firebase Security Rules dan Data Access

## 14.1 Prinsip umum

-   Deny by default.
-   Pengguna hanya dapat membaca dan mengubah dokumen miliknya.
-   Pengguna tidak dapat menulis koleksi konfigurasi klinis atau sistem.
-   Pengguna tidak dapat mengubah field yang seharusnya dikelola server.
-   Admin menggunakan mekanisme otorisasi yang berbeda dan diaudit.
-   Gunakan Firebase Emulator Suite untuk pengujian rules.
-   Jangan menganggap App Check sebagai pengganti autentikasi atau
    Security Rules.

## 14.2 Persyaratan rules

1.  Periksa bahwa `request.auth` tersedia.
2.  Periksa bahwa UID pada path sama dengan UID pengguna terautentikasi.
3.  Batasi field yang boleh dibuat dan diubah.
4.  Validasi tipe data dan panjang string.
5.  Tolak field tambahan yang tidak dikenal jika sesuai dengan skema.
6.  Larang pengguna biasa mengubah status review atau konfigurasi
    keselamatan.
7.  Batasi akses ke saved reflections berdasarkan kepemilikan.
8.  Pastikan penghapusan data hanya memengaruhi data pengguna yang
    meminta penghapusan.
9.  Gunakan server-side validation untuk tindakan yang memerlukan hak
    istimewa.
10. Uji akses lintas akun untuk memastikan tidak ada kebocoran data.

------------------------------------------------------------------------

# 15. Backend API Contract

Backend dapat menggunakan Cloud Functions atau layanan HTTPS terpisah.
Endpoint berikut adalah kontrak awal, bukan kewajiban untuk menggunakan
semua endpoint jika arsitektur proyek sudah memiliki padanan.

## 15.1 Endpoint

  ------------------------------------------------------------------------------------------------
  Method                  Endpoint                                         Tujuan
  ----------------------- ------------------------------------------------ -----------------------
  `POST`                  `/api/v1/sessions`                               Membuat sesi baru

  `GET`                   `/api/v1/sessions/{sessionId}`                   Mendapatkan status sesi
                                                                           milik pengguna

  `GET`                   `/api/v1/flows/{flowId}/next`                    Mendapatkan pertanyaan
                                                                           berikutnya sesuai
                                                                           jawaban

  `POST`                  `/api/v1/sessions/{sessionId}/answers`           Memvalidasi dan
                                                                           menyimpan pilihan
                                                                           jawaban

  `POST`                  `/api/v1/sessions/{sessionId}/safety-check`      Menjalankan aturan
                                                                           keselamatan yang telah
                                                                           disetujui

  `POST`                  `/api/v1/sessions/{sessionId}/response`          Meminta respons
                                                                           suportif dari Gemini
                                                                           melalui backend

  `POST`                  `/api/v1/sessions/{sessionId}/complete`          Menyelesaikan sesi

  `POST`                  `/api/v1/sessions/{sessionId}/save-reflection`   Menyimpan refleksi atas
                                                                           pilihan pengguna

  `GET`                   `/api/v1/reflections`                            Mengambil refleksi
                                                                           tersimpan milik
                                                                           pengguna

  `DELETE`                `/api/v1/reflections/{reflectionId}`             Menghapus satu refleksi

  `DELETE`                `/api/v1/account/data`                           Memulai penghapusan
                                                                           data sesuai kebijakan

  `GET`                   `/api/v1/app-config`                             Mendapatkan konfigurasi
                                                                           publik non-sensitif
  ------------------------------------------------------------------------------------------------

## 15.2 Aturan endpoint

-   Semua endpoint privat membutuhkan Firebase ID token yang valid.
-   Endpoint yang memanggil AI mempunyai rate limit.
-   Validasi payload dilakukan sebelum memanggil layanan eksternal.
-   Endpoint tidak menerima `userId` dari klien sebagai otoritas utama.
-   Semua akses harus memverifikasi kepemilikan sesi.
-   Gunakan idempotency atau perlindungan duplikasi untuk request yang
    dapat dikirim ulang.
-   Timeout dan retry dibatasi.
-   Error tidak boleh mengungkap API key, prompt internal, atau data
    pengguna lain.
-   Jangan menyimpan hasil AI sebelum melewati validasi.
-   Safety endpoint harus memiliki fallback yang tidak bergantung pada
    AI.

------------------------------------------------------------------------

# 16. State Management dan Konsistensi Sesi

## 16.1 State sesi

Sesi dapat menggunakan state: - `initial` - `loading` -
`questionReady` - `submittingAnswer` - `checkingSafety` -
`generatingResponse` - `responseReady` - `completed` -
`recoverableError` - `blockedForSafety`

Nama state dapat disesuaikan dengan pola arsitektur Flutter.

## 16.2 Perilaku

-   Cegah double tap yang mengirim jawaban ganda.
-   Simpan progress minimum yang dibutuhkan untuk melanjutkan sesi.
-   Jangan memulihkan sesi sensitif secara otomatis di layar terkunci
    tanpa mempertimbangkan privasi.
-   Jika aplikasi ditutup, status sesi ditangani berdasarkan kebijakan
    retensi.
-   Jika token kedaluwarsa, minta autentikasi ulang dengan aman.
-   Jika AI timeout, sediakan retry yang tidak membuat sesi duplikat.
-   Jika audio gagal, pengguna tetap dapat membaca teks.
-   Jika Firestore tidak dapat diakses, jangan berpura-pura bahwa
    jawaban telah tersimpan.

------------------------------------------------------------------------

# 17. Keamanan dan Privasi

## 17.1 Prinsip

-   Minimalkan pengumpulan data.
-   Transparan tentang penggunaan AI.
-   Riwayat bersifat opt-in atau sesuai keputusan produk yang
    diinformasikan dengan jelas.
-   Pisahkan data akun dari data refleksi.
-   Batasi retensi.
-   Beri pengguna kontrol untuk menghapus data.
-   Jangan gunakan data kesehatan mental untuk iklan bertarget.
-   Jangan gunakan percakapan untuk pelatihan model tanpa dasar hukum,
    tata kelola, dan persetujuan yang sesuai.
-   Tinjau ketentuan privasi penyedia AI sebelum produksi.

## 17.2 Data yang tidak boleh disimpan tanpa kebutuhan dan dasar yang jelas

-   Rekaman suara mentah pengguna.
-   Isi percakapan lengkap secara permanen.
-   Informasi identitas yang tidak diperlukan.
-   Token autentikasi.
-   API key.
-   Data sensitif dalam crash report atau analytics.
-   Konten percakapan pada notifikasi push.

## 17.3 Penghapusan data

-   Sediakan UI untuk menghapus refleksi satu per satu.
-   Sediakan UI untuk menghapus semua refleksi.
-   Sediakan proses penghapusan akun.
-   Penghapusan harus meliputi dokumen yang dikelola aplikasi dan
    memproses layanan terkait sesuai kebijakan.
-   Jika ada data yang harus dipertahankan untuk kewajiban hukum atau
    keamanan, jelaskan dasar dan retensinya.
-   Jangan mengklaim seluruh data telah dihapus dari semua sistem jika
    prosesnya belum selesai.

## 17.4 Regulasi

Sebelum peluncuran publik, tinjau kepatuhan terhadap UU Pelindungan Data
Pribadi Indonesia dan ketentuan lain yang berlaku. Jika cakupan produk
meluas ke skrining klinis atau klaim kesehatan yang lebih spesifik,
lakukan penilaian regulasi tambahan bersama pihak yang kompeten.

------------------------------------------------------------------------

# 18. Safety and Crisis Handling

## 18.1 Tujuan

Mencegah aplikasi meneruskan percakapan biasa ketika terdapat sinyal
yang memerlukan bantuan manusia atau respons keselamatan khusus.

## 18.2 Prinsip wajib

-   AI bukan satu-satunya penentu risiko.
-   Gunakan protokol dan konten yang ditinjau profesional.
-   Jangan mengandalkan kata kunci tunggal untuk mengambil keputusan
    kompleks.
-   Jangan memberikan diagnosis atau skor risiko yang belum tervalidasi.
-   Jika jalur keselamatan terpicu, jangan membiarkan AI menurunkan
    tingkat urgensinya.
-   Tampilkan informasi dengan bahasa sederhana dan tidak menghakimi.
-   Berikan pilihan untuk menghubungi orang tepercaya atau dukungan
    profesional.
-   Informasi darurat harus diverifikasi untuk wilayah target.
-   Safety flow harus tetap tersedia ketika Gemini atau backend AI
    gagal.
-   Jangan menampilkan materi gamifikasi dalam situasi krisis.

## 18.3 Pengujian keselamatan

Buat skenario uji yang disusun dan ditinjau tenaga profesional,
termasuk: - Pengguna menunjukkan tanda bahaya secara langsung. -
Pengguna menjawab tidak yakin. - Jawaban saling bertentangan. - AI
menghasilkan respons yang tidak sesuai. - AI timeout. - Backend tidak
tersedia. - Pengguna keluar dari sesi saat safety flow aktif. - Pengguna
memilih untuk tidak menjawab pertanyaan sensitif.

Kriteria kelulusan ditetapkan bersama peninjau profesional sebelum
rilis.

------------------------------------------------------------------------

# 19. Error Handling dan Fallback

## 19.1 Error kategori

-   Tidak ada koneksi.
-   Firebase Authentication gagal.
-   Firestore tidak tersedia.
-   Gemini API timeout atau error.
-   Output AI tidak valid.
-   TTS tidak didukung.
-   TTS gagal.
-   Sesi kedaluwarsa.
-   Permintaan dibatasi.
-   Terjadi masalah pada safety routing.

## 19.2 Prinsip respons

-   Jelaskan masalah dengan bahasa sederhana.
-   Beri opsi retry jika aman.
-   Jangan menyalahkan pengguna.
-   Jangan menampilkan stack trace atau detail backend.
-   Jangan membuat respons AI palsu jika permintaan gagal.
-   Pertahankan teks saat audio gagal.
-   Jangan memblokir akses ke informasi keselamatan karena layanan AI
    gagal.
-   Catat kode error teknis tanpa menyertakan konten sensitif.

Contoh microcopy: - "Suara belum bisa diputar. Kamu tetap bisa membaca
pertanyaannya." - "Koneksi sedang bermasalah. Coba lagi sebentar." -
"Sesi ini belum tersimpan. Periksa koneksi sebelum melanjutkan." -
"Respons belum tersedia. Kamu bisa mencoba lagi atau menyelesaikan
sesi."

------------------------------------------------------------------------

# 20. Performance, Reliability, and Cost Controls

## 20.1 Performance

-   Hindari memuat seluruh riwayat jika hanya diperlukan ringkasan.
-   Paginate daftar refleksi.
-   Cache katalog pertanyaan non-sensitif bila aman.
-   Hindari memanggil Gemini setiap kali widget dibangun ulang.
-   Debounce atau cegah permintaan berulang.
-   Batasi panjang konteks yang dikirim ke AI.
-   Gunakan timeout untuk panggilan eksternal.
-   Jangan menahan UI sambil menunggu TTS jika teks sudah tersedia.

## 20.2 Cost control

-   Tetapkan model Gemini melalui konfigurasi server.
-   Batasi jumlah request AI per sesi dan per akun.
-   Batasi panjang input/output.
-   Terapkan rate limiting.
-   Atur alert billing Firebase.
-   Monitor pemakaian token dan latensi tanpa mencatat isi percakapan.
-   Jangan mengirim permintaan AI yang sama berulang kali tanpa alasan.
-   Jangan membuat TTS cloud untuk pertanyaan statis jika audio sudah
    tersedia.
-   Sediakan fallback saat kuota habis.

## 20.3 Reliability

-   Retry hanya untuk error sementara yang aman diulang.
-   Gunakan idempotency untuk operasi yang dapat membuat data duplikat.
-   Jangan menyimpan hasil parsial sebagai hasil final.
-   Pastikan status sesi konsisten saat koneksi terputus.
-   Safety flow harus mempunyai fallback statis yang telah ditinjau.

------------------------------------------------------------------------

# 21. Analytics dan Observability

Analytics bersifat opsional dan harus dirancang untuk meminimalkan data
sensitif.

Event yang boleh dipertimbangkan: - `onboarding_viewed` -
`session_started` - `question_answered` tanpa menyimpan jawaban
sensitif - `session_completed` - `tts_started` - `tts_failed` -
`ai_request_failed` - `reflection_saved` - `reflection_deleted`

Hindari: - Mengirim isi percakapan ke analytics. - Mengirim label
perasaan yang sensitif jika tidak diperlukan. - Menyimpan prompt dan
response mentah pada log standar. - Memakai event untuk menargetkan
iklan berdasarkan kondisi mental.

Metrik produk: - Tingkat penyelesaian sesi. - Waktu respons AI. -
Persentase kegagalan TTS. - Tingkat error per endpoint. - Penggunaan
token agregat. - Persentase sesi yang disimpan secara sukarela. -
Tingkat keberhasilan penghapusan data.

Jangan menjadikan durasi penggunaan yang panjang sebagai indikator
keberhasilan utama. Aplikasi seharusnya membantu pengguna, bukan
mendorong ketergantungan.

------------------------------------------------------------------------

# 22. Testing Requirements

## 22.1 Unit tests

-   Validasi state sesi.
-   Pemilihan pertanyaan berikutnya.
-   Validasi pilihan jawaban.
-   Parsing output Gemini.
-   Validasi action code.
-   Pengelolaan status TTS.
-   Error mapping.
-   Penghapusan data.

## 22.2 Widget tests

-   Welcome.
-   Home.
-   Pilihan perasaan.
-   Pilihan situasi.
-   Pertanyaan adaptif.
-   Hasil AI.
-   Kontrol audio.
-   Riwayat.
-   Pengaturan privasi.
-   Safety routing.

## 22.3 Integration tests

-   Email/password registration dan login.
-   Google Sign-In sesuai kemampuan environment pengujian.
-   Reset password.
-   Membuat sesi dan menyimpan jawaban.
-   Mengambil pertanyaan berikutnya.
-   Mengirim konteks ke backend.
-   Memvalidasi hasil AI.
-   Memutar TTS dan menangani kegagalan.
-   Menyimpan dan menghapus refleksi.
-   Logout dan penghapusan akun.

## 22.4 Firebase tests

-   Firestore Security Rules dengan Emulator Suite.
-   Pengguna A tidak dapat membaca data pengguna B.
-   Pengguna biasa tidak dapat menulis konfigurasi admin.
-   Field tidak sah ditolak.
-   Request tanpa token ditolak.
-   Request dengan token tidak valid ditolak.
-   App Check diuji sesuai konfigurasi target.

## 22.5 Safety tests

-   Semua skenario kritis yang disetujui harus lulus.
-   AI tidak dapat mengubah safety state.
-   Safety content tersedia saat Gemini gagal.
-   Tidak ada rekomendasi berbahaya pada skenario uji yang ditentukan.
-   Respons tidak menyatakan diagnosis.
-   Tidak ada false claim bahwa bantuan profesional sudah dihubungi.
-   Jalur keluar dari sesi selalu tersedia bila sesuai protokol.

## 22.6 Visual QA

-   Bandingkan setiap layar dengan desain Stitch.
-   Uji ukuran layar yang umum.
-   Uji text scaling.
-   Uji kontras dan tap target.
-   Uji loading, error, selected, disabled, empty, dan audio-playing
    state.
-   Pastikan keyboard tidak muncul pada alur pilihan utama.
-   Pastikan tidak ada layout overflow.
-   Pastikan navigasi dan back button bekerja sesuai desain.

------------------------------------------------------------------------

# 23. Acceptance Criteria Global

Rilis MVP belum boleh dinyatakan selesai sampai persyaratan berikut
terpenuhi:

1.  Desain UI telah diperiksa terhadap sumber Stitch yang ditautkan
    melalui MCP.
2.  Semua layar inti sudah diimplementasikan dan dibandingkan secara
    visual.
3.  Login email/password dan Google Sign-In berfungsi.
4.  Pengguna dapat menjalankan sesi inti dengan pilihan tanpa mengetik.
5.  Pertanyaan bertahap mengikuti jawaban sebelumnya.
6.  Audio dapat diputar, dijeda, dihentikan, dan diulang sesuai
    kemampuan platform.
7.  Teks selalu tersedia sebagai alternatif audio.
8.  Gemini hanya dipanggil melalui backend.
9.  Output AI divalidasi sebelum ditampilkan.
10. Tidak ada diagnosis gangguan mental atau skor klinis tanpa validasi.
11. Safety flow tidak bergantung pada keberhasilan Gemini.
12. Firestore Security Rules telah diuji.
13. Data pengguna tidak dapat diakses akun lain.
14. Penghapusan refleksi dan penghapusan akun memiliki alur yang jelas.
15. API key dan secret tidak terdapat dalam bundle aplikasi.
16. Error dan kondisi offline ditangani dengan benar.
17. Unit, widget, integration, security, dan safety tests telah
    dijalankan sesuai cakupan.
18. Biaya Firebase dan AI mempunyai pemantauan dan batas penggunaan.
19. Kebijakan privasi, batas AI, dan informasi dukungan telah ditinjau.
20. Risiko yang belum terselesaikan terdokumentasi dan tidak
    disembunyikan.

------------------------------------------------------------------------

# 24. Roadmap Implementasi

Roadmap berikut merupakan urutan pekerjaan, bukan janji durasi tetap.

## Phase 0 --- Repository and Stitch audit

-   Periksa repository dan konfigurasi yang sudah ada.
-   Buka desain Stitch melalui MCP.
-   Buat screen inventory dan design token inventory.
-   Identifikasi kebutuhan akses dan dependensi.
-   Buat daftar pertanyaan yang belum terjawab.

**Output:** audit awal, pemetaan desain, daftar pekerjaan.

## Phase 1 --- Foundation

-   Siapkan struktur Flutter.
-   Siapkan Firebase project dan konfigurasi platform.
-   Implementasikan routing dan design system berdasarkan Stitch.
-   Tambahkan error state dasar.
-   Konfigurasikan environment development.

**Output:** aplikasi dapat berjalan dan navigasi dasar tersedia.

## Phase 2 --- Authentication

-   Email/password.
-   Google Sign-In.
-   Reset password.
-   Logout.
-   Penanganan token dan error.
-   Uji Firebase Security Rules.

**Output:** autentikasi dan akses data dasar berjalan.

## Phase 3 --- Guided session

-   Implementasikan pilihan perasaan.
-   Implementasikan pilihan situasi.
-   Implementasikan pertanyaan adaptif.
-   Implementasikan session state.
-   Implementasikan progress, back, skip, dan error states.

**Output:** alur pilihan berfungsi menggunakan data uji.

## Phase 4 --- TTS

-   Integrasikan `flutter_tts`.
-   Uji bahasa Indonesia pada perangkat.
-   Tambahkan audio state dan kontrol.
-   Tambahkan fallback teks.
-   Tambahkan pengaturan autoplay dan kecepatan bila didukung.

**Output:** pertanyaan dan respons teks dapat dibacakan.

## Phase 5 --- Backend and Gemini

-   Buat endpoint sesi.
-   Buat request validation.
-   Simpan Gemini key di secret server.
-   Implementasikan prompt dan output schema.
-   Implementasikan safety validation dan fallback.
-   Tambahkan rate limiting serta monitoring biaya.

**Output:** respons AI terintegrasi dengan validasi.

## Phase 6 --- Privacy and safety

-   Finalisasi alur persetujuan dan privasi.
-   Finalisasi protokol safety dengan profesional.
-   Implementasikan konten safety statis.
-   Implementasikan kontrol riwayat dan penghapusan.
-   Audit data yang dikirim ke layanan eksternal.

**Output:** kontrol privasi dan safety siap diuji.

## Phase 7 --- QA and release readiness

-   Jalankan seluruh tes.
-   Lakukan visual comparison dengan Stitch.
-   Uji pada perangkat Android nyata.
-   Uji error API, offline, dan kegagalan TTS.
-   Audit keamanan dan biaya.
-   Dokumentasikan risiko tersisa.

**Output:** laporan QA dan keputusan kesiapan rilis.

------------------------------------------------------------------------

# 25. Risiko dan Mitigasi

  -----------------------------------------------------------------------
  Risiko                  Dampak                  Mitigasi
  ----------------------- ----------------------- -----------------------
  AI memberi respons      Pengguna menerima saran Output schema,
  tidak tepat             yang tidak sesuai       validasi, prompt
                                                  guardrails, fallback,
                                                  dan review

  Pengguna mengira AI     Ekspektasi keliru dan   Label AI yang jelas,
  psikolog manusia        ketergantungan          disclosure, dan batas
                                                  kemampuan

  Kebocoran data          Dampak privasi serius   Minimisasi data,
                                                  Security Rules, secret
                                                  management, audit akses

  TTS tidak tersedia      Alur audio terganggu    Fallback teks dan uji
                                                  bahasa perangkat

  API habis kuota atau    Fitur tidak tersedia    Rate limit, budget
  mahal                   atau biaya meningkat    alert, model
                                                  configuration, dan
                                                  fallback

  Sesi tidak konsisten    Jawaban hilang atau     Session state,
                          duplikat                idempotency, dan
                                                  penanganan retry

  Safety flow salah       Risiko keselamatan      Review profesional, tes
                                                  skenario, dan safety
                                                  fallback

  UI tidak sesuai desain  Kualitas produk menurun Stitch source-of-truth
                                                  dan visual QA

  Penghapusan data tidak  Risiko kepatuhan        Prosedur penghapusan
  lengkap                                         dan audit data stores

  Penggunaan data         Risiko privasi          Review terms, data
  provider tidak sesuai                           minimization, dan
                                                  konfigurasi provider
  -----------------------------------------------------------------------

------------------------------------------------------------------------

# 26. Keputusan yang Masih Perlu Dikonfirmasi

Hal berikut tidak boleh diasumsikan secara diam-diam oleh developer:

1.  Apakah sesi pertama dapat digunakan tanpa login atau login wajib
    sebelum memulai?
2.  Apakah riwayat sesi default-nya tidak disimpan, atau pengguna diberi
    pilihan menyimpan pada akhir sesi?
3.  Batas usia minimum untuk rilis awal.
4.  Apakah aplikasi hanya berbahasa Indonesia pada MVP.
5.  Versi model Gemini yang dipilih dan ketentuan data yang berlaku.
6.  Protokol safety dan resource dukungan yang disetujui profesional.
7.  Kebijakan retensi data dan penghapusan.
8.  Apakah aplikasi akan dirilis hanya untuk Android terlebih dahulu.
9.  Apakah backend menggunakan Firebase Cloud Functions atau layanan
    server terpisah.
10. Apakah perlu dashboard admin untuk mengelola pertanyaan dan konten
    pada fase awal.

Jika keputusan belum dibuat, implementasikan dengan konfigurasi yang
mudah diubah dan dokumentasikan asumsi. Jangan membuat keputusan klinis
atau kebijakan privasi hanya demi menyelesaikan UI.

------------------------------------------------------------------------

# 27. Definition of Done

Sebuah fitur dianggap selesai jika:

-   Persyaratan fungsionalnya terpenuhi.
-   Desain mengikuti Stitch.
-   Loading, empty, error, disabled, dan success states telah
    dipikirkan.
-   Aksesibilitas dasar telah diuji.
-   Tidak ada secret dalam kode klien.
-   Firebase Rules dan otorisasi telah diuji.
-   Penanganan data sensitif sesuai kebijakan.
-   Tes otomatis yang relevan lulus.
-   Tidak ada regresi pada fitur lain.
-   Dokumentasi dan asumsi diperbarui.
-   Risiko yang belum diselesaikan tercatat.

------------------------------------------------------------------------

# 28. Instruksi Akhir untuk Coding Agent

Implementasikan Ruang Cerita secara bertahap dan aman. Mulailah dengan
audit repository serta membaca desain Stitch yang sudah ditautkan
melalui MCP. Setelah itu, buat screen inventory dan mapping desain ke
widget Flutter sebelum menulis UI.

Gunakan Firebase Authentication untuk email/password dan Google Sign-In,
Firestore untuk data yang memang perlu disimpan, serta backend tepercaya
untuk semua panggilan Gemini API. Gunakan TTS perangkat pada MVP agar
tidak menambah ketergantungan layanan TTS cloud.

Jangan menambahkan diagnosis, skor klinis, fitur terapi otomatis, atau
klaim kesehatan yang tidak diminta dan tidak tervalidasi. Prioritaskan
alur pilihan yang mudah, audio yang dapat dikontrol, respons suportif
yang aman, privasi, dan kualitas implementasi.

**Jangan mengklaim bahwa desain Stitch telah diakses atau cocok secara
visual sebelum benar-benar memeriksanya melalui MCP dan melakukan visual
QA. Jangan menyatakan implementasi selesai sebelum acceptance criteria
dan pengujian yang relevan terpenuhi.**
