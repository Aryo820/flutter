import 'package:flutter/material.dart';
import 'package:ppkd_b6/database/db/db_helper.dart';
import 'package:ppkd_b6/database/views/home.dart';
import 'package:ppkd_b6/database/views/registrations.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    final email = emailController.text.trim();
    final pass = passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Isi semua field!')));
      return;
    }

    final pengguna = await DBHelper().loginUser(email, pass);

    // Cek apakah widget masih terpasang (mounted) sebelum menggunakan context
    if (!mounted) return;

    if (pengguna != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => Home()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal! email atau Password salah.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 4, 104, 235),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.medication,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "JagaDosis",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 4, 104, 235),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: Text(
                  "Selamat Datang",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  "Masuk untuk mengelola jadwal minum \nobat Anda.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email"),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: "Masukkan Email",
                          filled: true,
                          fillColor: Color(0xffF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email tidak boleh kosong";
                          } else if (!value.contains('@')) {
                            return "Format email tidak valid";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Text("Password"),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "Masukkan Password",
                          filled: true,
                          fillColor: Color(0xffF5F7FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password tidak boleh kosong";
                          } else if (value.length < 6) {
                            return "Password terlalu singkat";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Lupa Password?",
                            style: TextStyle(
                              color: Color(0xFF005AB6),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Color.fromARGB(255, 4, 104, 235),
                          ),
                          onPressed: login,
                          // () {
                          //   if (_formKey.currentState!.validate()) {
                          //     showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return AlertDialog(
                          //           title: Text("Login Berhasil"),
                          //           content: Text("Selamat Datang"),
                          //           actions: [
                          //             TextButton(
                          //               onPressed: () {
                          //                 Navigator.pushNamed(
                          //                   context,
                          //                   Home.routeName,
                          //                 );
                          //               },
                          //               child: Text("Lanjut"),
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //     );
                          //   }
                          // },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Belum Punya Akun? "),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Daftar2.routeName);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 4, 104, 235),
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Daftar Sekarang",
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
