import 'package:flutter/material.dart';

import 'package:shopping_list/screens/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: const TextTheme().copyWith(),
      ),
      home: const HomeScreen(),
    );
  }
}
