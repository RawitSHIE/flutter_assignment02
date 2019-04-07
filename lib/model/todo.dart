import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

final String _tableName = "todo";
final String _columnId = "id";
final String _columnTitle = "title";
final String _columnDone = "done";

Todo todoFromMap(String str) {
  final jsonData = json.decode(str);
  return Todo.fromMap(jsonData);
}

String todoToMap(Todo data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Todo {
  int id;
  String title;
  int done;

  Todo({
    this.id,
    this.title,
    this.done,
  });

  factory Todo.fromMap(Map<String, dynamic> todo) => new Todo(
        id: todo[_columnId],
        title: todo[_columnTitle],
        done: todo[_columnDone],
      );

  Map<String, dynamic> toMap() => {
        _columnId: id,
        _columnTitle: title,
        _columnDone: done,
      };
}

class TodoProvider {
  TodoProvider();
  static final TodoProvider db = TodoProvider();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todo.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $_tableName ("
          "$_columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$_columnTitle TEXT,"
          "$_columnDone INTEGER"
          ")");
    });
  }

  newTodo(Todo newTodo) async {
    final db = await database;
    // var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Todo");
    var todo = await db.rawInsert(
        "INSERT Into $_tableName ($_columnTitle, $_columnDone)"
        "VALUES(?,?)",
        [newTodo.title, newTodo.done]);
    print(newTodo.title);
    return todo;
  }

  getConditionTodo(int done) async {
    final db = await database;
    var res = await db
        .query(_tableName, where: "$_columnDone = ?", whereArgs: [done]);
    List<Todo> undone =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return undone;
  }

  getAll() async {
    final db = await database;
    var res = await db.query(_tableName);
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  updateDoneState({Todo todo}) async {
    final db = await database;
    Todo updated = Todo(
      id: todo.id,
      title: todo.title,
      done: todo.done == 1 ? 0 : 1,
    );

    var res = await db.update(_tableName, updated.toMap(),
        where: "$_columnId = ?", whereArgs: [todo.id]);
    return res;
  }

  deleteDoneTodo() async {
    final db = await database;
    db.delete(_tableName, where: "$_columnDone = ?", whereArgs: [1]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from $_tableName");
  }
}
