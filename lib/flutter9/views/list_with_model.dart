import 'package:flutter/material.dart';
import 'package:ppkd_b6/flutter9/data/obat_data_with_model.dart';

class ListWithModelDataDay16 extends StatefulWidget {
  const ListWithModelDataDay16({super.key});

  @override
  State<ListWithModelDataDay16> createState() => _ListWithModelDataDay16State();
}

class _ListWithModelDataDay16State extends State<ListWithModelDataDay16> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Expanded(
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     itemCount: hiraganaList.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       print(index);
          //       return ListTile(
          //         title: Text(
          //           hiraganaList[index]["character"],
          //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: daftarObatWithModel.length,
              itemBuilder: (BuildContext context, int index) {
                final data = daftarObatWithModel[index];
                return Container(
                  color: index % 2 == 0 ? Colors.blue : Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.nama,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data.deskripsi,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data.harga.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
