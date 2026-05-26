import 'package:flutter/material.dart';
import 'package:ppkd_b6/flutter9/data/obat_list.dart';

class MapDataDay16 extends StatefulWidget {
  const MapDataDay16({super.key});

  @override
  State<MapDataDay16> createState() => _MapDataDay16State();
}

class _MapDataDay16State extends State<MapDataDay16> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: daftarObat.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: index % 2 == 0 ? Colors.blue : Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      daftarObat[index]["nama"],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      daftarObat[index]["deskripsi"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      daftarObat[index]["harga"],
                      style: TextStyle(
                        fontSize: 18,
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
    );
  }
}
