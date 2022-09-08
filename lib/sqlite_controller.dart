import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dog_model.dart';

late Database database;

const DB_NAME = 'doggie_database2.db';
const TABLE_NAME = 'dogs2';

class SQLiteController {
  Future<void> initializeDatabase() async {
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.

    database = await openDatabase(
      join(await getDatabasesPath(), 'doggie_database2.db'),
    );

    database.execute(
      'CREATE TABLE IF NOT EXISTS $TABLE_NAME (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)',
    );

  }

// Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    // await db.insert(
    //   'dogs',
    //   dog.toMap(),
    //   conflictAlgorithm: ConflictAlgorithm.ignore,
    // );

    await db.rawInsert('INSERT INTO $TABLE_NAME (NAME,AGE) VALUES(\'${dog.name}\',${dog.age})');
  }

// A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>> dogs() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    //final List<Map<String, dynamic>> maps = await db.query('dogs');

    final List<Map<String, dynamic>> maps = await db.rawQuery('Select * from $TABLE_NAME');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.

    // UPDATE dogs SET name = 'milu' WHERE id = 1

    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(String name) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      TABLE_NAME,
      // Use a `where` clause to delete a specific dog.
      where: 'name = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [name],
    );
  }
}


