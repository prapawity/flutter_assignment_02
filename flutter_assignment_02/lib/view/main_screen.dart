import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/database/myDB.dart';

class main_screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return main_screen_state();
  }
}

class main_screen_state extends State<main_screen> {
  static TodoProvider todo = TodoProvider();
  int len1 = 0;
  int len2 = 0;
  List<Todo> show1 = [];
  List<Todo> show2 = [];
  List<Todo> cases = [];
  int _state = 0;
  @override
  Widget build(BuildContext context) {
    final List list_button = <Widget>[
      IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/form_screen");
        },
      ),
      IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.black,
        ),
        onPressed: () async {
          cases = show2;
          var del = await todo.getAllString();
          for (var item in del) {
            if (item.values.toList()[2] == 1) {
              await todo.delete(item.values.toList()[0]);
              for (var i = 0; i < show2.length; i++) {
                if (show2[i].id == item.values.toList()[0]) {
                  await cases.removeAt(i);
                }
              }
            }
          }
          setState(() {
            show2 = [];
          });
        },
      )
    ];

    return DefaultTabController(
      length: 2,
      initialIndex: _state,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Todo",
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[list_button[_state]],
          ),
          backgroundColor: Colors.white,
          body: _state == 0
              ? Container(
                  color: Colors.red,
                  child: FutureBuilder<List<Todo>>(
                    future: todo.getAll(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Todo>> snapshot) {
                      show1 = [];
                      len1 = 0;
                      if (snapshot.hasData) {
                        for (var items in snapshot.data) {
                          if (items.done == false) {
                            show1.add(items);
                            len1++;
                          }
                        }
                        return len1 != 0
                            ? ListView.builder(
                                itemCount: show1.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Todo item = show1[index];
                                  return Column(children: <Widget>[ListTile(
                                    title: Text(item.title),
                                    trailing: Checkbox(
                                      onChanged: (bool value) async {
                                        setState(() {
                                          item.done = value;
                                        });
                                        todo.update(item);
                                      },
                                      value: item.done,
                                    ),
                                  ),Divider(color: Colors.white,)],);
                                },
                              )
                            : Center(
                                child: Text("No Data Found... "),
                              );
                      } else {
                        return Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white));
                      }
                    },
                  ),
                )
              : Container(
                  color: Colors.pink,
                  child: FutureBuilder<List<Todo>>(
                    future: todo.getAll(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Todo>> snapshot) {
                      show2 = [];
                      len2 = 0;
                      if (snapshot.hasData) {
                        for (var items in snapshot.data) {
                          if (items.done == true) {
                            show2.add(items);
                            len2++;
                          }
                        }
                        return len2 != 0
                            ? ListView.builder(
                                itemCount: show2.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Todo item = show2[index];
                                  return Column(
                                    children: <Widget>[
                                       ListTile(
                                    
                                    title: Text(item.title),
                                    trailing: Checkbox(
                                      onChanged: (bool value) async {
                                        setState(() {
                                          item.done = value;
                                        });
                                        todo.update(item);
                                      },
                                      value: item.done,
                                    ),
                                  ),Divider(color: Colors.white,)
                                    ],
                                  );
                                },
                              )
                            : Center(
                                child: Text("No Data Found..."),
                              );
                      } else {
                        return Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white));
                      }
                    },
                  ),
                ),
          bottomNavigationBar: new Theme(
            data: Theme.of(context).copyWith(
                canvasColor: Colors.white,
                textTheme: Theme.of(context)
                    .textTheme
                    .copyWith(caption: new TextStyle(color: Colors.black))),
            child: BottomNavigationBar(
              fixedColor: Colors.red,
              currentIndex: _state,
              onTap: onTabTapped,
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: new Icon(Icons.format_list_bulleted),
                  title: Text("Task"),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: new Icon(Icons.done_all),
                  title: Text("Completed"),
                ),
              ],
            ),
          )),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      todo.open("todo.db");
      _state = index;
    });
  }
}
