import 'package:flutter/material.dart';
import 'package:ppkd_b6/daftar.dart';
import 'package:ppkd_b6/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JagaDosis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005AB6)),
      ),
      // home: LoginScreen(),
      initialRoute: LoginScreen.routeName,

      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        Daftar.routeName: (context) => const Daftar(),
      },
    );
  }
}
