import 'package:flutter/material.dart';

class Addlist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddlisState();
  }
}

class AddlisState extends State {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Create list"),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(padding: EdgeInsets.all(20.0), children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Thing to do!!",
                  hintText: "You know  what you could do.",
                ),
                keyboardType: TextInputType.text,
                onSaved: (value) => print(value),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please input value";
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
                onPressed: () {
                  _formKey.currentState.validate();
                },
              )
            ]),
          ),
        ));
  }
}
