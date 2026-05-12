import 'package:flutter/material.dart';

class SizedBoxDay8 extends StatelessWidget {
  const SizedBoxDay8({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("SizedBox")),

      body: Column(
        children: [
          Text("Selamat Pagi"),
          Row(children: [Text("PENGUMUMAN")]),
          SizedBox(height: 20),
          Row(children: [Text("Hari ini adalah hari Jumat")]),

          Row(children: [Text("Hari ini adalah hari Jumat")]),

          SizedBox(height: 20),

          Row(
            children: [
              Text("Tanggal : "),
              SizedBox(width: 200),
              Text("08 Mei 2026"),
            ],
          ),
        ],
      ),
    );
  }
}
