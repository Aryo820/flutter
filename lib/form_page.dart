import 'package:flutter/material.dart';
import 'package:ppkd_b6/flutter10/login.dart';
import 'package:ppkd_b6/listview.dart';
import 'package:ppkd_b6/local/database/preferences.dart';
import 'package:ppkd_b6/navigation.dart';
import 'package:ppkd_b6/profile.dart';

class FormPage2 extends StatefulWidget {
  static const String routeName = '/form_page';
  const FormPage2({super.key});

  @override
  State<FormPage2> createState() => _FormPage2State();
}

class _FormPage2State extends State<FormPage2> {
  // ignore: prefer_final_fields
  bool _isDarkMode = false;
  String? selected;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int _selectedIndex = 0;

  void _logOut() async {
    await PreferenceHandler.logOut();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  // ignore: prefer_final_fields
  List<Widget> _widgetOptions = <Widget>[
    ListViewSaya(),
    InteractiveFormPage(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "JagaDosis",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Icon(Icons.menu_book, size: 48, color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text('Form Input', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.import_contacts),
              title: Text("Syarat & Ketentuan"),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
              },
            ),
            ListTile(leading: Icon(Icons.sunny), title: Text("Mode Tampilan")),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Kategori Produk"),
              onTap: () {
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.date_range),
              title: Text("Pilih Tanggal"),
              onTap: () {
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text("Pilih Jam"),
              onTap: () {
                _onItemTapped(3);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log Out"),
              onTap: _logOut,
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information),
            label: "Obat",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
