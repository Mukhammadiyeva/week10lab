import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as pth;

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = pth.join(databasesPath, 'user.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE user (id INTEGER PRIMARY KEY, username TEXT, password TEXT, phone TEXT, email TEXT, address TEXT)');
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int userId = await dbClient.insert('user', user.toMap());
    return userId;
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      'user',
      columns: ['id', 'username', 'password', 'phone', 'email', 'address'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User(
        maps[0]['id'],
        maps[0]['username'],
        maps[0]['password'],
        maps[0]['phone'],
        maps[0]['email'],
        maps[0]['address'],
      );
    } else {
      throw Exception('User not found');
    }
  }

  Future<int> getUserId(User user) async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      'user',
      columns: ['id'],
      where:
          'username = ? AND password = ? AND phone = ? AND email = ? AND address = ?',
      whereArgs: [
        user.username,
        user.password,
        user.phone,
        user.email,
        user.address,
      ],
    );

    if (maps.isNotEmpty) {
      return maps[0]['id'];
    } else {
      throw Exception('User ID not found');
    }
  }

  // test read
  Future<void> testRead(String db_name) async {
    var databasesPath = await getDatabasesPath();
    String path = pth.join(databasesPath, db_name);

    Database database = await openDatabase(path, version: 1);

    List<Map> list = await database.rawQuery('SELECT * FROM user');
    print(list);
  }
}

class User {
  int? id;
  String username;
  String password;
  String phone;
  String email;
  String address;

  User(this.id, this.username, this.password, this.phone, this.email,
      this.address);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'username': username,
      'password': password,
      'phone': phone,
      'email': email,
      'address': address,
    };
    return map;
  }
}
