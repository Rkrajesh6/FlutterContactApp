import 'package:flutterdrwableex/model/Contacts.dart';
import 'package:flutterdrwableex/utils/Constants.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "Contactlist.db";

    var contactDatabase =
        await openDatabase(path, version: 1, onCreate: _onCreateDb);
    return contactDatabase;
  }

  void _onCreateDb(Database db, int version) async {
    await db.execute('CREATE TABLE ${Constants.contactTable}(${Constants.colId} INTEGER PRIMARY KEY AUTOINCREMENT, ${Constants.colName} TEXT, '
        '${Constants.colMobile} TEXT, ${Constants.colFavorite} INTEGER, ${Constants.colLandline} TEXT, ${Constants.colImagePath} TEXT)');

  }

  // Fetch Operation: Get all contactModel objects from database
  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $contactTable order by $colFavorite ASC');
    var result = await db.query(Constants.contactTable, orderBy: '${Constants.colName} ASC');
    return result;
  }

  // Fetch Operation: Get all contactModel objects from database
  Future<List<Map<String, dynamic>>> getFavoriteContactMapList() async {
    Database db = await this.database;
    var result = await db.query(Constants.contactTable, orderBy: '${Constants.colName} ASC', where: '${Constants.colFavorite} = ?',whereArgs: [1]);
    return result;
  }

  // Insert Operation: Insert a contactModel object to database
  Future<int> insertContact(Contacts conact) async {
    Database db = await this.database;
    var result = await db.insert(Constants.contactTable, conact.toMap());
    return result;
  }

  // Update Operation: Update a contactModel object and save it to database
  Future<int> updateContact(Contacts conact) async {
    var db = await this.database;
    var result = await db.update(Constants.contactTable, conact.toMap(), where: '${Constants.colId} = ?', whereArgs: [conact.id]);
    return result;
  }

  // Delete Operation: Delete a contactModel object from database
  Future<int> deleteContact(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM ${Constants.contactTable} WHERE ${Constants.colId} = $id');
    return result;
  }

  // Get number of contactModel objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from ${Constants.contactTable}');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'contactModel List' [ List<contactModel> ]
  Future<List<Contacts>> getContactList() async {

    var contactMapList = await getContactMapList(); // Get 'Map List' from database
    int count = contactMapList.length;         // Count the number of map entries in db table

    List<Contacts> contactList = List<Contacts>();
    // For loop to create a 'contactModel List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contactList.add(Contacts.fromMapObject(contactMapList[i]));
    }

    return contactList;
  }

  Future<List<Contacts>> getFavoriteContactList() async {

    var contactMapList = await getFavoriteContactMapList(); // Get 'Map List' from database
    int count = contactMapList.length;         // Count the number of map entries in db table

    List<Contacts> contactList = List<Contacts>();
    // For loop to create a 'contactModel List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contactList.add(Contacts.fromMapObject(contactMapList[i]));
    }

    return contactList;
  }
}
