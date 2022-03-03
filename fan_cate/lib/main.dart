import 'package:fan_cate/screens/login_screen.dart';
import 'package:fan_cate/screens/root_screen.dart';
import 'package:fan_cate/theme/app_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<AppNotifier>(
        create: (_) => AppNotifier(),
        child: RootPage(),
      ),
      // const RootPage(),
    );
  }
}
