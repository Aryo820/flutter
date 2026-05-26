import 'package:flutter/material.dart';

class ListObat extends StatefulWidget {
  const ListObat({super.key});

  @override
  State<ListObat> createState() => _ListObatState();
}

class _ListObatState extends State<ListObat> {
  List<String> daftarObat = [
    'Paracetamol',
    'Amoxicillin',
    'Ibuprofen',
    'Omeprazole',
    'Cetirizine',
    'Metformin',
    'Amlodipine',
    'Asam Mefenamat',
    'Antalgin',
    'Ranitidine',
    'Vitamin C',
    'Simvastatin',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: daftarObat.length,
            itemBuilder: (BuildContext context, int index) {
              print(index);
              return Text(daftarObat[index]);
            },
          ),
        ),
      ],
    );
  }
}
