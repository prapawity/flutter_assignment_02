import 'package:sqflite/sqflite.dart';

final String tableTodo = "todo";
final String columnId = "_id";
final String columnBody = "body";
final String columnShow = "Show";

class Todo {
  int id;
  String body;
  bool show;

  Todo();
  Todo.formMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.body = map[columnBody];
    this.show = map[columnShow] == 1;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnBody: body,
      columnShow: show,
    };

    if (id != null) {
      map[columnId] = id;
    }

    return map;
  }

@override
  String toString() {
    // TODO: implement toString
    return '${this.id}, ${this.body} ${this.show}';
  }
}

class TodoProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableTodo (
        $columnId integer primary key autoincrement,
        $columnBody text not null,
        $columnShow integer not null
      )
      ''');
    });
  }

  Future<Todo> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  // Future<Todo> getTodo(int id) async {
  //   List<Map<String, dynamic>> maps = await db.query(tableTodo,
  //       columns: [columnId, columnShow, columnBody, columnShow],
  //       where: "$columnId = ?",
  //       whereArgs: [id]);
  //   if (maps.length > 0) {
  //     return new Todo.formMap(maps.first);
  //   }
  //   return null;
  // }

  Future<Todo> getTodo(int id) async {
    List<Map<String, dynamic>> maps = await db.query(tableTodo,
        columns: [columnId, columnBody, columnShow],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Todo.formMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Todo todo) async {
    return db.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future<List<Todo>> getAll() async {
    await this.open("todo.db");
    var res =
        await db.query(tableTodo, columns: [columnId, columnBody, columnShow]);
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.formMap(c)).toList() : [];
    return list;
  }

  Future<List<Map>> getAllString() async {
    await this.open("todo.db");
    var res =
        await db.query(tableTodo, columns: [columnId, columnBody, columnShow]);
    // var list = res.isNotEmpty ? res.map((c) => Todo.toString(c)) : [];
    return res;
  }

  Future close() async => db.close();
}
