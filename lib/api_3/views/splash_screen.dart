import 'package:flutter/material.dart';
import 'package:ppkd_b6/api_3/service/token_storage.dart';
import 'package:ppkd_b6/api_3/views/home_page.dart';
import 'package:ppkd_b6/api_3/views/login_page.dart';

/// SplashScreen: mengecek token di secure storage.
/// Jika token ada → langsung ke HomePage (tidak perlu login ulang).
/// Jika tidak ada  → ke LoginPage.
class AbsensiSplashScreen extends StatelessWidget {
  const AbsensiSplashScreen({super.key});

  Future<bool> _checkLogin() async {
    return TokenStorage.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: FutureBuilder<bool>(
        future: _checkLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fingerprint, size: 80, color: Colors.white),
                  SizedBox(height: 24),
                  Text(
                    'PPKD Absensi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 40),
                  CircularProgressIndicator(color: Colors.white),
                ],
              ),
            );
          }

          // Navigasi setelah build selesai
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (snapshot.data == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            }
          });

          return const Center(child: CircularProgressIndicator(color: Colors.white));
        },
      ),
    );
  }
}
