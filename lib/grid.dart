import 'package:flutter/material.dart';

Widget _buildMedicineCard(String medicineName, Color color) {
  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Center(
          child: Text(medicineName, style: TextStyle(fontSize: 15)),
        ),
      ),
      Positioned(
        top: 5,
        right: 5,
        child: Icon(Icons.info_outline, color: Colors.white, size: 20),
      ),
    ],
  );
}

class LayoutingGrid extends StatelessWidget {
  const LayoutingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("JagaDosis"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              SizedBox(height: 15),
              Text("Nama"),
              TextField(
                decoration: InputDecoration(
                  hintText: "Masukan Nama",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              Text("Email"),
              TextField(
                decoration: InputDecoration(
                  hintText: "Masukan Email",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              Text("No Hp"),
              TextField(
                decoration: InputDecoration(
                  hintText: "Masukan No HP",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              Text("Deskripsi"),
              TextField(
                decoration: InputDecoration(
                  hintText: "Masukan Deskripsi",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
              ),
              SizedBox(height: 5, width: 10),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 5,
                children: [
                  _buildMedicineCard("Paracetamol", Colors.red),
                  _buildMedicineCard("Tolak Angin", Colors.blue),
                  _buildMedicineCard("Panadol", Colors.green),
                  _buildMedicineCard("Oskadon", Colors.grey),
                  _buildMedicineCard("Betadine", Colors.pink),
                  _buildMedicineCard("Antangin", Colors.cyan),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
