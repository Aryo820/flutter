import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InteractiveFormPage extends StatefulWidget {
  const InteractiveFormPage({super.key});

  @override
  State<InteractiveFormPage> createState() => _InteractiveFormPageState();
}

class _InteractiveFormPageState extends State<InteractiveFormPage> {
  bool _isChecked = false;
  bool _isDarkMode = false;
  String? selected;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Syarat & Ketentuan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                        ),
                        // Text(
                        //   "Saya Menyetujui Persyaratan",
                        //   style: TextStyle(
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            _isChecked
                                ? "Saya Menyetujui"
                                : "Saya Belum Menyetujui",
                            style: TextStyle(
                              color: _isChecked ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Switch(
                      value: _isDarkMode,
                      onChanged: (val) {
                        setState(() {
                          _isDarkMode = val;
                        });
                      },
                    ),
                    Text(_isDarkMode ? "Nyala" : "Mati"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            DropdownButton<String>(
              value: selected,
              hint: Text("Pilih Kategori"),
              items: ['Bodrex', 'Paracetamol', 'Tolak Angin', 'Lainnya'].map((
                String val,
              ) {
                return DropdownMenuItem(value: val, child: Text(val));
              }).toList(),
              onChanged: (String? newVal) {
                setState(() {
                  selected = newVal;
                });
              },
            ),
            SizedBox(height: 12),
            Text("Pilih Obat: $selected"),

            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text(
                DateFormat(
                  'EEE, dd MMMM yyyy',
                  'id_ID',
                ).format(selectedDate ?? DateTime.now()),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
              child: Text(
                selectedTime == null ? "" : selectedTime!.format(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
