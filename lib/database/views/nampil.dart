// import 'package:flutter/material.dart';
// import 'package:ppkd_b6/constant/app_color.dart';
// import 'package:ppkd_b6/day_20/database/db_helper.dart';
// import 'package:ppkd_b6/day_20/models/user_model_sql.dart';
// import 'package:ppkd_b6/extension/navigator.dart';
// import 'package:ppkd_b6/utils/button.dart';
// import 'package:sqlite_viewer2/sqlite_viewer.dart';

// class HomeScreenDay20 extends StatefulWidget {
//   const HomeScreenDay20({super.key});

//   @override
//   State<HomeScreenDay20> createState() => _HomeScreenDay20State();
// }

// class _HomeScreenDay20State extends State<HomeScreenDay20> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   void register() async {
//     final email = emailController.text.trim();
//     final pass = passwordController.text;

//     if (email.isEmpty || pass.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Isi semua field woi!')));
//       return;
//     }

//     final user = UserModelSql(email: email, password: pass);
//     bool success = await DBHelper().registerUser(user);

//     // Cek apakah widget masih terpasang (mounted) sebelum menggunakan context
//     if (!mounted) return;

//     if (success) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Akun berhasil dibuat')));
//       setState(() {});
//       // Tambahkan navigasi ke halaman login jika perlu
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Email sudah terdaftar!')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           textTitleForm("Email"),
//           SizedBox(height: 12),

//           textFormConst(
//             controller: emailController,
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Email tidak boleh kosong";
//               } else if (!value.contains('@')) {
//                 return "Format email tidak valid";
//               }
//               return null;
//             },
//             hintText: "Masukkan Email",
//           ),
//           SizedBox(height: 24),

//           textTitleForm("Password"),
//           SizedBox(height: 12),

//           textFormConst(
//             controller: passwordController,
//             hintText: "Masukkan Password",
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return "Password tidak boleh kosong";
//               } else if (value.length < 6) {
//                 return "Password terlalu singkat";
//               }
//               return null;
//             },
//           ),

//           DefaultButton(text: "Tambah", onPressed: register),
//           Expanded(
//             child: FutureBuilder<List<UserModelSql>>(
//               future: DBHelper().getAllUsers(),
//               builder: (context, snapshot) {
//                 // Menampilkan indikator loading saat menunggu data
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 // Menangani jika terjadi error
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Terjadi kesalahan: ${snapshot.error}'),
//                   );
//                 }

//                 // Menangani jika data kosong atau tidak ada data
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('Tidak ada data pengguna.'));
//                 }

//                 // Jika data berhasil didapatkan
//                 final daftarPengguna = snapshot.data!;

//                 return ListView.builder(
//                   itemCount: daftarPengguna.length,
//                   itemBuilder: (context, index) {
//                     final user = daftarPengguna[index];
//                     return Card(
//                       child: ListTile(
//                         leading: const CircleAvatar(child: Icon(Icons.person)),
//                         title: Text(user.email),
//                         subtitle: Text('Password: ${user.password}'),
//                         trailing: IconButton(
//                           icon: const Icon(
//                             Icons.edit_document,
//                             color: Colors.blueGrey,
//                           ),
//                           onPressed: () => _showBottomSheet(context, user),
//                         ),
//                         onTap: () => _showBottomSheet(context, user),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           DefaultButton(
//             text: "Lihat Database",
//             onPressed: () {
//               context.push(DatabaseList());
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _showBottomSheet(BuildContext context, UserModelSql user) {
//     final emailController = TextEditingController(text: user.email);
//     final passwordController = TextEditingController(text: user.password);

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 'Kelola Pengguna',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Row untuk Tombol Update dan Delete
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // Tombol Update
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                     ),
//                     icon: const Icon(Icons.edit, color: Colors.white),
//                     label: const Text(
//                       'Update',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () async {
//                       if (user.id != null) {
//                         final updatedUser = UserModelSql(
//                           id: user.id,
//                           email: emailController.text.trim(),
//                           password: passwordController.text,
//                         );
//                         bool success = await DBHelper().updateUser(updatedUser);
//                         if (success && context.mounted) {
//                           Navigator.pop(context);
//                           setState(() {});
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Data berhasil diperbarui'),
//                             ),
//                           );
//                         }
//                       }
//                     },
//                   ),

//                   // Tombol Delete
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                     ),
//                     icon: const Icon(Icons.delete, color: Colors.white),
//                     label: const Text(
//                       'Delete',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () async {
//                       if (user.id != null) {
//                         await DBHelper().deleteUser(user.id!);
//                         if (context.mounted) {
//                           Navigator.pop(context);
//                           setState(() {});
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Data berhasil dihapus'),
//                             ),
//                           );
//                         }
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   TextFormField textFormConst({
//     required String hintText,
//     required String? Function(String?)? validator,
//     required TextEditingController controller,
//   }) {
//     return TextFormField(
//       onChanged: (value) {
//         setState(() {});
//       },
//       validator: validator,
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         enabledBorder: borderConst(),
//         focusedBorder: borderConst(),
//         border: borderConst(),
//       ),
//     );
//   }

//   OutlineInputBorder borderConst() {
//     return OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide(color: AppColor.greyColorDivider),
//     );
//   }

//   Widget textTitleForm(String text) => Row(
//     children: [
//       Text(text, style: TextStyle(color: AppColor.greyColorOr, fontSize: 12)),
//     ],
//   );
// }
