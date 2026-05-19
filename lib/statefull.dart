import 'package:flutter/material.dart';

class StateFull extends StatefulWidget {
  const StateFull({super.key});

  @override
  State<StateFull> createState() => _StateFullState();
}

class _StateFullState extends State<StateFull> {
  bool tampilkan = false;
  bool suka = false;
  bool teks = false;
  int angka = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JagaDosis"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Center(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                setState(() {
                  tampilkan = !tampilkan;
                });
              },
              child: Text(
                tampilkan ? "Hi Saya Adalah Software Enginer" : "Klik Ini Deh",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 15),
            IconButton(
              onPressed: () {
                setState(() {
                  suka = !suka;
                });
              },
              icon: Icon(
                Icons.favorite,
                color: suka ? Colors.red : Colors.grey,
              ),
            ),
            Text(
              suka ? "Aku Suka Kamuuh" : "Tapii Aku Engga Sukaa",
              style: TextStyle(
                fontSize: 25,
                color: suka ? Colors.red : Colors.grey,
              ),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () {
                setState(() {
                  teks = !teks;
                });
              },
              child: Text(
                teks ? "Sembunyikan" : "Tampilkan",
                style: TextStyle(fontSize: 16),
              ),
            ),
            teks
                ? Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "JagaDosis Adalah Aplikasi Pengingat Minum Obat",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  )
                : SizedBox.shrink(),
            InkWell(
              splashColor: Colors.redAccent,
              onTap: () {
                print("Akhhh Pria Solo Itu Lagii");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Image.asset("assets/images/oslo.jpg", height: 200),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  angka++;
                });
                print("Di tekan sekali");
              },
              onDoubleTap: () {
                setState(() {
                  angka += 2;
                });
                print("Di tekan dua kali");
              },
              onLongPress: () {
                setState(() {
                  angka += 3;
                });
                print("Di tekan lama");
              },
              child: Container(
                child: Image.asset("assets/images/oslo.jpg", height: 200),
              ),
            ),
            Text(
              angka.toString(),
              style: TextStyle(fontSize: 50, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            angka--;
          });
        },
        child: Icon(Icons.minimize_sharp),
      ),
    );
  }
}
