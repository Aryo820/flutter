import 'package:flutter/material.dart';
import 'package:ppkd_b6/database/db/db_helper.dart';
import 'package:ppkd_b6/database/models/user_model_sql.dart';
import 'package:ppkd_b6/database/views/logins.dart';

class Daftar2 extends StatefulWidget {
  const Daftar2({super.key});
  static const String routeName = '/registrations';

  @override
  State<Daftar2> createState() => _Daftar2State();
}

class _Daftar2State extends State<Daftar2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Isi semua field woi!')));
      return;
    }

    final user = UserModelSql(name: name, email: email, password: pass);
    bool success = await DBHelper().registerUser(user);

    // Cek apakah widget masih terpasang (mounted) sebelum menggunakan context
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Akun berhasil dibuat')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen2()),
      );

      // Tambahkan navigasi ke halaman login jika perlu
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Email sudah terdaftar!')));
    }
  }

  // Controllers untuk nama, email, dan password
  // final _namaController = TextEditingController();
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();

  // @override
  // void dispose() {
  //   _namaController.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }
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
                _summaryRow('Nama Lengkap', nameController.text),
                const SizedBox(height: 8),
                _summaryRow('Email', emailController.text),
                const SizedBox(height: 8),
                _summaryRow('Password', '*' * passwordController.text.length),
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
                onPressed: register,
                // () {
                //   // Close dialog first, then navigate
                //   Navigator.pop(context);
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (_) => Home()),
                //   );
                // },
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
              // ── Header ──────────────────────────────
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
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: 'Masukkan Nama Lengkap',
                          filled: true,
                          fillColor: Color(0xffF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          hintText: 'Masukkan Email',
                          filled: true,
                          fillColor: Color(0xffF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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

                      // 3. Password (wajib)
                      const Text('Password'),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true, // Menyembunyikan teks password
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: 'Masukkan Password',
                          filled: true,
                          fillColor: Color(0xffF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // ── Primary button: Daftar ─────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              4,
                              104,
                              235,
                            ),
                          ),
                          onPressed: _onDaftarPressed,
                          child: const Text(
                            'Daftar Sekarang',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── TextButton: back to login ────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sudah punya akun?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 4, 104, 235),
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Masuk Di Sini",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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
