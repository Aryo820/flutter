import 'package:flutter/material.dart';
import 'package:ppkd_b6/flutter10/confirm.dart';

class Daftar2 extends StatefulWidget {
  const Daftar2({super.key});
  static const String routeName = '/daftar';

  @override
  State<Daftar2> createState() => _Daftar2State();
}

class _Daftar2State extends State<Daftar2> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture input values
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomorHpController = TextEditingController();
  final _kotaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _nomorHpController.dispose();
    _kotaController.dispose();
    super.dispose();
  }

  void _onDaftarPressed() {
    if (_formKey.currentState!.validate()) {
      // Valid → show summary dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ringkasan Pendaftaran'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryRow('Nama Lengkap', _namaController.text),
                const SizedBox(height: 8),
                _summaryRow('Email', _emailController.text),
                const SizedBox(height: 8),
                _summaryRow(
                  'Nomor HP',
                  _nomorHpController.text.isEmpty
                      ? '-'
                      : _nomorHpController.text,
                ),
                const SizedBox(height: 8),
                _summaryRow('Kota Asal', _kotaController.text),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 4, 104, 235),
                ),
                onPressed: () {
                  // Close dialog first, then navigate
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KonfirmasiScreen(
                        namaLengkap: _namaController.text,
                        kota: _kotaController.text,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Lanjut',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _summaryRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

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
              const SizedBox(height: 24),
              const Center(
                child: Text('Buat Akun Baru', style: TextStyle(fontSize: 20)),
              ),
              const Center(
                child: Text(
                  'Lengkapi data diri Anda untuk mendaftar',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              // ── Form ───────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Nama Lengkap (wajib)
                      const Text('Nama Lengkap'),
                      TextFormField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nama Lengkap',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama lengkap tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 2. Email (wajib, harus mengandung @)
                      const Text('Email'),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Email',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          } else if (!value.contains('@')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // 3. Nomor HP (opsional)
                      const Text('Nomor HP (Opsional)'),
                      TextFormField(
                        controller: _nomorHpController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Nomor HP',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: const OutlineInputBorder(),
                        ),
                        // No validator — field is optional
                      ),
                      const SizedBox(height: 16),

                      // 4. Kota Asal (wajib — data tambahan sesuai tema)
                      const Text('Kota Asal'),
                      TextFormField(
                        controller: _kotaController,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Kota Asal',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kota asal tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // ── Primary button: Daftar ─────────────────────────
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
                          onPressed: _onDaftarPressed,
                          child: const Text(
                            'Daftar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      // ── Secondary button: back to login ────────────────
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Sudah Punya Akun? Masuk',
                            style: TextStyle(
                              color: Color.fromARGB(255, 4, 104, 235),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
