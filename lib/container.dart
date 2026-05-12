import 'package:flutter/material.dart';

class ContainerDay8 extends StatelessWidget {
  const ContainerDay8({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Container"),
        backgroundColor: const Color.fromARGB(255, 67, 204, 71),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/oslo.jpg"),
              ),
            ),
          ),

          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.all(16),
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.yellow, width: 10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurStyle: BlurStyle.outer,
                  color: Colors.red,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Saldo sisa dikit"),
                    Text("Rp. 100.000"),
                    Column(children: [Icon(Icons.payment), Text("Bayar")]),
                    Column(children: [Icon(Icons.touch_app), Text("Top Up")]),
                    Column(children: [Icon(Icons.search), Text("Eksplor")]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
