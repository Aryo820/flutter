import 'dart:developer';

import 'package:path/path.dart';
import 'package:ppkd_b6/database/models/user_model_sql.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'jagadosis.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  // Fungsi Register CREATE
  Future<bool> registerUser(UserModelSql users) async {
    final db = await database;
    try {
      await db.insert('users', users.toMap());
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // Fungsi Login GET
  Future<UserModelSql?> loginUser(String email, String password) async {
    final db = await database;

    final List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    log(results.toString());

    if (results.isNotEmpty) {
      return UserModelSql.fromMap(results.first);
    }
    return null;
  }

  // Fungsi untuk mengambil semua data user
  Future<List<UserModelSql>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query('users');

    return results.map((map) => UserModelSql.fromMap(map)).toList();
  }

  // Fungsi untuk menghapus user berdasarkan ID
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk memperbarui data user
  Future<bool> updateUser(UserModelSql users) async {
    final db = await database;
    try {
      int count = await db.update(
        'users',
        users.toMap(),
        where: 'id = ?',
        whereArgs: [users.id],
      );
      return count > 0;
    } catch (e) {
      return false;
    }
  }
}
