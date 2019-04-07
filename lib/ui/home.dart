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
      future: TodoProvider.db.getConditionTodo(0),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0){
            return Center(
              child: Text("No data found.."),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Todo item = snapshot.data[index];
              return ListTile(
                title: Text(item.title),
                leading: Text("${index+1}"),
                subtitle: Text("Task ID. ${item.id}"),
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
      future: TodoProvider.db.getConditionTodo(1),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snap1) {
        if (snap1.hasData) {
          if (snap1.data.length == 0){
            return Center(
              child: Text("No data found.."),
            );
          }
          return ListView.builder(
            itemCount: snap1.data.length,
            itemBuilder: (BuildContext context, int index) {
              Todo item = snap1.data[index];
              return ListTile(
                title: Text(item.title),
                leading: Text("${index+1}"),
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

  @override
  Widget build(BuildContext context) {
    // page list
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
        onPressed: () async{
          await TodoProvider.db.deleteDoneTodo();
          setState(() {
          });
        },
      )
    ];



    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        actions: <Widget>[topbar[_index]],
      ),
      body: Center(child: _children[_index]),
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
