import 'package:flutter/material.dart';
import 'listadd.dart';

class Todolist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TodolistState();
  }
}

class TodolistState extends State {
  int _index = 0;

  final List<Widget> _children = [Text('Todo'), Text('Completed')];

  @override
  Widget build(BuildContext context) {

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
        onPressed: () {},
      )
    ];

    // TODO: implement build
    return new Scaffold(
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
