import 'package:flutter/material.dart';
import '../model/todo.dart';

class Addlist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddlistState();
  }
}

class AddlistState extends State {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("New Subject"),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(padding: EdgeInsets.all(20.0), children: [
              TextFormField(
                controller: _title,
                decoration: InputDecoration(
                  labelText: "Subject",
                  hintText: "Keep Track your tasks.",
                ),
                keyboardType: TextInputType.text,
                onSaved: (value) => (value),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill subject";
                  }
                },
              ),
              RaisedButton(
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
                color: Theme.of(context).accentColor,
                elevation: 4.0,
                splashColor: Colors.blueGrey,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    Todo todo = Todo(title: _title.text, done: 0);
                    await TodoProvider.db.newTodo(todo);
                    Navigator.pop(context, "/home");
                  }
                },
              )
            ]),
          ),
        ));
  }
}
