import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/scol_list.dart';
import '../models/list_etudiants.dart';

class dbuse {
  static final dbuse _dbHelper = dbuse._internal();
  Database? db;

  dbuse._internal();
  factory dbuse() => _dbHelper;

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(
        join(await getDatabasesPath(), 'scol.db'),
        onCreate: (database, version) {
          database.execute(
              'CREATE TABLE classes(codClass INTEGER PRIMARY KEY, nomClass TEXT, nbreEtud INTEGER)');
          database.execute(
              'CREATE TABLE etudiants(id INTEGER PRIMARY KEY, codClass INTEGER, nom TEXT, prenom TEXT, datNais TEXT, FOREIGN KEY(codClass) REFERENCES classes(codClass))');
        },
        version: 1,
      );
    }
    return db!;
  }

  Future<int> insertClass(ScolList list) async {
    return await db!.insert('classes', list.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertEtudiants(ListEtudiants etud) async {
    return await db!.insert('etudiants', etud.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ScolList>> getClasses() async {
    final List<Map<String, dynamic>> maps = await db!.query('classes');
    return List.generate(maps.length, (i) {
      return ScolList(
        maps[i]['codClass'] ?? 0,
        maps[i]['nomClass'] ?? '',
        maps[i]['nbreEtud'] ?? 0,
      );
    });
  }

  Future<List<ListEtudiants>> getEtudiants(int code) async {
    final List<Map<String, dynamic>> maps =
    await db!.query('etudiants', where: 'codClass = ?', whereArgs: [code]);
    return List.generate(maps.length, (i) {
      return ListEtudiants(
        maps[i]['id'] ?? 0,
        maps[i]['codClass'] ?? 0,
        maps[i]['nom'] ?? '',
        maps[i]['prenom'] ?? '',
        maps[i]['datNais'] ?? '',
      );
    });
  }

  Future<int> deleteList(ScolList list) async {
    return await db!.delete("classes", where: "codClass = ?", whereArgs: [list.codClass]);
  }

  Future<int> deleteStudent(ListEtudiants student) async {
    return await db!.delete("etudiants", where: "id = ?", whereArgs: [student.id]);
  }
}
