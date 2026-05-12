import 'package:flutter/material.dart';

class PaddingDay8 extends StatelessWidget {
  const PaddingDay8({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SizedBox"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        // padding: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.only(left: 0.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(children: [Text("Selamat Pagi, Habibie")]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Pembayaran untuk berlangganan sebesear Rp. 300.000, segera lakukan pembayaran",
                style: TextStyle(fontSize: 20),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "Pembayaran untuk berlangganan sebesear Rp. 300.000, segera lakukan pembayaran",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                "Pembayaran untuk berlangganan sebesear Rp. 300.000, segera lakukan pembayaran",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
