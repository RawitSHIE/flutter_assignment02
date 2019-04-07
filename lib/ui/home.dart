import 'package:flutter/material.dart';
import 'listadd.dart';
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

  ListTile customCheckBox({Todo item, int index}) {
    return ListTile(
      title: Text(item.title),
      // leading: Text("${index + 1}"),
      // subtitle: Text("Task ID. ${item.id}"),
      trailing: Checkbox(
        activeColor: Colors.blue,
        onChanged: (bool value) {
          TodoProvider.db.updateDoneState(todo: item);
          setState(() {});
        },
        value: item.done == 1 ? true : false,
      ),
    );
  }

  FutureBuilder checkboxList({int done}) {
    return FutureBuilder<dynamic>(
      future: TodoProvider.db.getConditionTodo(done),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text("No data found.."),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Todo item = snapshot.data[index];
              return Card(
                child: Column(
                  children: <Widget>[
                    customCheckBox(item: item, index: index),
                    // Divider(
                    //   color: Colors.black,
                    // )
                  ],
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
    // page list element
    final List<Widget> _children = [
      checkboxList(done: 0),
      checkboxList(done: 1)
    ];
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
        onPressed: () async {
          await TodoProvider.db.deleteDoneTodo();
          setState(() {});
        },
      )
    ];

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
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
