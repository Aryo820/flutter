import 'package:flutter/material.dart';
import 'package:ppkd_b6/daftar.dart';
import 'package:ppkd_b6/form_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
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
                child: Text("Selamat Datang", style: TextStyle(fontSize: 20)),
              ),
              Center(
                child: Text(
                  "Silahkan Masuk Untuk Mengelola Jadwal Anda",
                  style: TextStyle(fontSize: 12),
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
                        decoration: InputDecoration(
                          hintText: "Masukkan Email",
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(12),
                            // borderSide: BorderSide(color: Colors.blue),
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
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Masukkan Password",
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(),
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
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Lupa Password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 4, 104, 235),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Login Berhasil"),
                                    content: Text("Selamat Datang"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            FormPage2.routeName,
                                          );
                                        },
                                        child: Text("Lanjut"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, Daftar.routeName);
                            // if (_formKey.currentState!.validate()) {
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return AlertDialog(
                            //         title: Text("Login Berhasil"),
                            //         content: Text("Selamat Datang"),
                            //       );
                            //     },
                            //   );
                            // }
                          },
                          child: Text(
                            "Daftar",
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
