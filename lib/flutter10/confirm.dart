import 'package:flutter/material.dart';

class KonfirmasiScreen extends StatelessWidget {
  final String namaLengkap;
  final String kota;

  const KonfirmasiScreen({
    super.key,
    required this.namaLengkap,
    required this.kota,
  });

  static const String routeName = '/konfirmasi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // ── Header identical to login ──────────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 4, 104, 235),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medication,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'JagaDosis',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 4, 104, 235),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // ── Success icon ───────────────────────────────────────────
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.green.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── Confirmation message ───────────────────────────────────
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Terima kasih, $namaLengkap dari $kota telah mendaftar.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Akun Anda berhasil dibuat. Silakan masuk untuk mulai\nmengelola jadwal pengobatan Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 40),

              // ── Button: back to login ──────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            4,
                            104,
                            235,
                          ),
                        ),
                        onPressed: () {
                          // Pop back to root (login) — adjust if using named routes
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text(
                          'Kembali ke Halaman Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
