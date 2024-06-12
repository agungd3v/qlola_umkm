import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static final _databaseName = "local.db";
  static final _databaseVersion = 1;
  static final _databaseTable = "orders";

  static final _id = "_id";
  static final _transaction = "_transaction";
  static final _outletId = "_outletid";
  static final _productId = "_productid";
  static final _productName = "_productname";
  static final _productPrice = "_productprice";
  static final _quantity = "_quantity";
  static final _total = "_total";
  static final _status = "_status";
  static final _createdAt = "_createdat";
  static final _updatedAt = "_updatedat";
  static final _other = "_other";

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();

    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_databaseTable (
            $_id INTEGER PRIMARY KEY,
            $_transaction VARCHAR(255) NOT NULL,
            $_outletId INTEGER NOT NULL,
            $_productId INTEGER NOT NULL DEFAULT 0,
            $_productName VARCHAR(255) NOT NULL DEFAULT '',
            $_productPrice DOUBLE NOT NULL DEFAULT 0,
            $_quantity INTEGER NOT NULL,
            $_total DOUBLE NOT NULL,
            $_status TEXT NOT NULL,
            $_createdAt TIMESTAMP,
            $_updatedAt TIMESTAMP,
            $_other BOOLEAN DEFAULT FALSE
          )
          '''
        );
      }
    );
  }
}