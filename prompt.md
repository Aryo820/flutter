Instruksi Pengerjaan Aplikasi Flutter: Absensi PPKD
Kamu adalah Flutter Developer Expert. Tugas kamu adalah membuat aplikasi Flutter "Absensi PPKD" secara bertahap (step-by-step) dari nol hingga selesai. Ikuti semua spesifikasi, arsitektur, dan aturan yang ada di dokumen ini. Kerjakan difolder lib/absensi

PENTING: Jangan buat semua file sekaligus. Kerjakan secara bertahap. Tanyakan ke saya jika saya siap untuk lanjut ke tahap berikutnya.

📌 1. Tech Stack & Dependencies
Framework: Flutter (Stable)
State Management: Provider
HTTP Client: Dio
Local Storage: SharedPreferences
Maps & Location: geolocator, geocoding, google_maps_flutter
Utilities: intl (format tanggal), image_picker (foto profil)

📂 2. Arsitektur Folder
Gunakan struktur folder berikut:

lib/├── main.dart├── config/│   └── api_config.dart├── models/│   ├── user_model.dart│   ├── absen_model.dart│   ├── history_model.dart│   ├── training_model.dart│   └── stats_model.dart├── services/│   ├── api_service.dart         # Dio instance & Interceptors│   ├── auth_service.dart│   ├── absen_service.dart│   └── profile_service.dart├── providers/│   ├── auth_provider.dart│   ├── absen_provider.dart│   ├── profile_provider.dart│   └── theme_provider.dart├── utils/│   ├── shared_prefs.dart│   ├── location_helper.dart│   └── theme.dart├── widgets/│   ├── custom_button.dart│   └── loading_widget.dart└── screens/    ├── auth/    │   ├── login_screen.dart    │   └── register_screen.dart    ├── dashboard/    │   └── dashboard_screen.dart    ├── history/    │   └── history_screen.dart    └── profile/        ├── profile_screen.dart        └── edit_profile_screen.dart

🌐 3. Konfigurasi API (Dio)
Base URL: http://10.0.2.2:8000/api (Gunakan IP ini agar jalan di Android Emulator). Tambahkan /api di belakangnya.
Headers Default:
Accept: application/json
Content-Type: application/json
Auth Interceptor: Setiap request yang membutuhkan autentikasi harus otomatis menyertakan header Authorization: Bearer <token> yang diambil dari SharedPreferences. Jika mendapat response 401, hapus token dan arahkan ke Login.

📡 4. Daftar Endpoint & Spesifikasi
Auth
POST /register
Body: {"name": "", "email": "", "password": "", "jenis_kelamin": "L/P", "profile_photo": "", "batch_id": 1, "training_id": 16}
Response 200: {"message": "...", "data": {"token": "...", "user": {...}}}
Simpan token ke SharedPreferences.
POST /login
Body: {"email": "", "password": ""}
Response 200: {"message": "Login berhasil", "data": {"token": "...", "user": {...}}}
GET /trainings (Public - untuk dropdown register)
Response: {"data": [{"id": 1, "title": "..."}]}
GET /batches (Public - untuk dropdown register)
Absensi (Memerlukan Token)
POST /absen/check-in
Body: {"attendance_date": "YYYY-MM-DD", "check_in": "HH:MM", "check_in_lat": -6.1, "check_in_lng": 106.1, "check_in_address": "Jakarta", "status": "masuk"}
POST /absen/check-out
Body: {"attendance_date": "YYYY-MM-DD", "check_out": "HH:MM", "check_out_lat": -6.1, "check_out_lng": 106.1, "check_out_location": "-6.1, 106.1", "check_out_address": "Jakarta"}
POST /izin
Body: {"date": "YYYY-MM-DD", "alasan_izin": "Sakit"}
GET /absen/today?attendance_date=YYYY-MM-DD
Cek apakah user sudah absen masuk/pulang hari ini.
GET /absen/stats?start=YYYY-MM-DD&end=YYYY-MM-DD
Response: {"data": {"total_absen": 14, "total_masuk": 12, "total_izin": 2, "sudah_absen_hari_ini": true}}
GET /absen/history?start=YYYY-MM-DD&end=YYYY-MM-DD
Response: {"data": [{"id": 1, "attendance_date": "...", "check_in_time": "...", "check_out_time": "...", "status": "masuk/izin", ...}]}
DELETE /absen/{id}
Hapus riwayat absen.
Profile (Memerlukan Token)
GET /profile
Response: {"data": {"id": 1, "name": "", "email": "", "profile_photo": "url"}}
PUT /profile
Body: {"name": "", "email": ""}
PUT /profile/photo
Body: {"profile_photo": "data:image/png;base64,...."}

📱 5. Spesifikasi UI & Logika per Layar
A. Auth Screens
Login: Form email & password. Tombol submit. Jika sukses, simpan token, navigasi ke Dashboard (pushAndRemoveUntil).
Register: Form name, email, password, jenis_kelamin (dropdown L/P), training (dropdown dari API), batch (dropdown dari API). Saat submit, panggil POST /register.
B. Dashboard Screen
Tampilkan Greeting: "Halo, [Nama User]" dan tanggal hari ini (gunakan intl).
Map Mini: Tampilkan GoogleMap dengan ukuran sekitar 200px height. Ambil lokasi saat ini (Geolocator) dan taruh marker di peta.
Statistik: Panggil GET /absen/stats. Tampilkan Total Absen, Total Masuk, Total Izin.
Tombol Aksi:
"Absen Masuk" (Panggil POST /absen/check-in)
"Absen Pulang" (Panggil POST /absen/check-out)
"Ajukan Izin" (Pindah halaman form izin -> POST /izin)
Panggil GET /absen/today untuk mendisable tombol Absen Masuk jika sudah absen.
C. History Screen
Panggil GET /absen/history.
Tampilkan ListView berisi Card. Setiap card menampilkan: Tanggal, Jam Masuk, Jam Pulang, Lokasi, Status.
Setiap card memiliki ikon tempat sampah (delete). Jika diklik, show dialog konfirmasi, lalu panggil DELETE /absen/{id}. Refresh list setelah hapus.
D. Profile Screen
Panggil GET /profile. Tampilkan foto profil (CircleAvatar, jika null tampilkan inisial nama), nama, email.
Tombol Edit Profile -> Navigasi ke Edit Profile Screen.
Tombol Logout -> Hapus token dari SharedPreferences, navigasi ke Login.
(Bonus) Toggle Switch untuk Dark Mode / Light Mode di pojok kanan atas.
E. Edit Profile Screen
Pre-fill form nama dan email dari data profile sebelumnya.
Saat save, panggil PUT /profile.
(Bonus) Tombol ganti foto profil -> ImagePicker -> convert ke base64 -> PUT /profile/photo.

🎨 6. Theming & Bonus
Buat ThemeProvider menggunakan ChangeNotifier untuk menyimpan state tema (ThemeMode.light / ThemeMode.dark). Simpan preferensi ke SharedPreferences.
Sediakan toggle switch di Profile Screen untuk mengganti tema.
Gunakan MaterialApp.router atau MaterialApp dengan themeMode: context.watch<ThemeProvider>().themeMode.

🚀 7. Urutan Pengerjaan (Prompt Steps)
Kerjakan tahap demi tahap. Setiap tahap selesai, berhenti dan tanyakan "Lanjut ke tahap berikutnya?".

TAHAP 1: Setup pubspec.yaml, api_config.dart, api_service.dart (Dio + Interceptor), dan shared_prefs.dart.
TAHAP 2: Buat Models (User, Training, Absen, Stats, History) dan Providers (Auth, Theme).
TAHAP 3: Buat UI Login & Register Screen lengkap dengan fungsi API.
TAHAP 4: Buat UI Dashboard (Greeting, Map Mini, Stats) dan Logika Absen Masuk/Pulang (Geolocator).
TAHAP 5: Buat UI History & Delete Absen.
TAHAP 6: Buat UI Profile, Edit Profile, dan Logout.
TAHAP 7: Integrasi Dark Mode & Finishing main.dart.
Mulai dari TAHAP 1 sekarang. Keluarkan kode untuk file-file di Tahap 1.