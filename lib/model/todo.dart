import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

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
        id: todo["id"],
        title: todo["title"],
        done: todo["done"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "done": done,
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
    String path = join(documentsDirectory.path, "Todo.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Todo ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "title TEXT,"
          "done INTEGER"
          ")");
    });
  }

  newTodo(Todo newTodo) async {
    final db = await database;
    // var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Todo");
    var todo = await db.rawInsert(
        "INSERT Into Todo (title, done)"
        "VALUES(?,?)",
        [ newTodo.title, newTodo.done]);
    print(newTodo.title);
    return todo;
  }

  getConditionTodo(int done) async {
    final db = await database;
    var res = await db.query("Todo", where: "done = ?", whereArgs: [done]);
    List<Todo> undone =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return undone;
  }

  getAll() async{
    final db = await database;
    var res = await db.query("Todo");
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  updateDoneState({Todo todo}) async {
    final db = await database;
    Todo updated = Todo(
      id: todo.id,
      title: todo.title,
      done: todo.done == 1? 0 : 1,
    );

    var res = await db
        .update("Todo", updated.toMap(), where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  deleteDoneTodo() async {
    final db = await database;
    db.delete("Todo", where: "done = ?", whereArgs: [1]);
  }

  deleteAll() async {
    final  db = await database;
    db.rawDelete("Delete * from Todo");
  }
}
