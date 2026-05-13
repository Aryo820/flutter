import 'package:flutter/material.dart';

class ListViewSaya extends StatelessWidget {
  const ListViewSaya({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JagaDosis"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.cyanAccent,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        physics: BouncingScrollPhysics(),
        children: [
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: "Masukan Nama Pelanggan",
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: "Masukan Kontak Pelanggan",
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: "Masukan Alamat Pelanggan",
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: "Masukan Nama Obat",
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.medical_information),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Riwayat Obat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset("assets/images/oslo.jpg", fit: BoxFit.cover),
            ),
            title: Text("Paracetamol"),
            subtitle: Text("Obat Pusing"),
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset("assets/images/oslo.jpg", fit: BoxFit.cover),
            ),
            title: Text("Tolak Angin"),
            subtitle: Text("Obat Masuk Angin"),
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset("assets/images/oslo.jpg", fit: BoxFit.cover),
            ),
            title: Text("Panadol"),
            subtitle: Text("Obat Pusing"),
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset("assets/images/oslo.jpg", fit: BoxFit.cover),
            ),
            title: Text("Enervon C"),
            subtitle: Text("Vitamin C"),
            trailing: Icon(Icons.arrow_forward),
          ),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset("assets/images/oslo.jpg", fit: BoxFit.cover),
            ),
            title: Text("Amoxcilin"),
            subtitle: Text("Obat Batuk"),
            trailing: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
