import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ppkd_b6/database/views/home.dart';
import 'package:ppkd_b6/database/views/logins.dart';
import 'package:ppkd_b6/database/views/registrations.dart';
import 'package:ppkd_b6/local/database/preferences.dart';
import 'package:ppkd_b6/local/views/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', " ");
  PreferenceHandler.init();
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
      // home: ListWithModelDataDay16(),
      initialRoute: SplashScreen.routeName,

      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        // LoginScreen.routeName: (context) => const LoginScreen(),
        LoginScreen2.routeName: (context) => const LoginScreen2(),
        // Daftar.routeName: (context) => const Daftar(),
        Daftar2.routeName: (context) => const Daftar2(),
        // FormPage2.routeName: (context) => const FormPage2(),
        Home.routeName: (context) => const Home(),
      },
    );
  }
}
