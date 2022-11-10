import 'package:flutter/material.dart';
import 'package:healthcare_mania_v2/Screens/edit_screen.dart';
import 'package:healthcare_mania_v2/Screens/list_screen.dart';
import 'package:healthcare_mania_v2/Screens/login_screen.dart';
import 'package:healthcare_mania_v2/Screens/preview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare Mania',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  ListScreen(),
      routes: {
        EditScreen.id:(BuildContext context) => const EditScreen(),
        ListScreen.id:(BuildContext context) =>  ListScreen(),
        LoginScreen.id:(BuildContext context) => const LoginScreen(),
        PreviewScreen.id:(BuildContext context) => PreviewScreen(),
      },
    );
  }
}

