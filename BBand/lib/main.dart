import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app_state.dart';
import 'src/home.dart';


void main() {
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeBand',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        // textTheme: GoogleFonts.aBeeZeeTextTheme(
        //   Theme.of(context).textTheme,
        // ),
      ),

      home: const MyHomePage(title: 'BeBand'),

    );
  }
}
