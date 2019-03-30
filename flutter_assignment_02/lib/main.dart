import 'package:flutter/material.dart';
import 'view/main_screen.dart';
import 'view/formScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        // is not restarted.
        brightness:  Brightness.dark,
      ),
      //home: MyHomePage(),
      initialRoute: "/",
      routes: {
        "/": (context) => main_screen(),
        "/form_screen": (context) => form_screen(),
        
        // "/second": (context) =>(Regis_Screen()),
        // "/second" :(context) => DetailScreen(title: "test",),R
        },
    );
  }
}
