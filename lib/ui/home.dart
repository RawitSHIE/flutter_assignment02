import 'package:flutter/material.dart';
import 'listadd.dart';
import 'dart:async';
import '../model/todo.dart';

class Todolist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TodolistState();
  }
}

class TodolistState extends State {
  int _index = 0;
  bool _value2 = false;
  // Container todoview() {
  //   return Container(
  //     padding: EdgeInsets.all(8),
  //     child: Center(
  //       child: Column(
  //         children: <Widget>[
  //           CheckboxListTile(
  //             value: _value2,
  //             onChanged: (bool value) => setState(() => _value2 = value),
  //             title: Text('test'),
  //             subtitle: Text('subtest'),
  //             secondary: new Icon(Icons.add_alert),
  //             activeColor: Colors.blue,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  FutureBuilder undone() {
    return FutureBuilder<dynamic>(
      future: TodoProvider.db.getConditionTodo(doneState: 0),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Todo item = snapshot.data[index];
              return ListTile(
                title: Text(item.title),
                leading: Text(item.id.toString()),
                trailing: Checkbox(
                  onChanged: (bool value) {
                    TodoProvider.db.updateDoneState(todo: item);
                    setState(() {});
                  },
                  value: item.done == 1 ? true : false,
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  FutureBuilder done() {
    return FutureBuilder<dynamic>(
      future: TodoProvider.db.getConditionTodo(doneState: 1),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Todo item = snapshot.data[index];
              return ListTile(
                title: Text(item.title),
                leading: Text(item.id.toString()),
                trailing: Checkbox(
                  onChanged: (bool value) {
                    TodoProvider.db.updateDoneState(todo: item);
                    setState(() {});
                  },
                  value: item.done == 1 ? true : false,
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Container completeview() {
    return Container(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [undone(), done()];
    final List topbar = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Addlist()));
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          TodoProvider.db.deleteDoneTodo();
        },
      )
    ];

    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        actions: <Widget>[topbar[_index]],
      ),
      body: Center(child: _children[_index]),
      // body:
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('Task')),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), title: Text("Completed"))
        ],
        onTap: (int index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
