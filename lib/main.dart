import 'package:flutter/material.dart';
import 'package:bcall/pages/identity_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Relationship App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE05688)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF5F8),
      ),
      home: const IdentityPage(),
    );
  }
}
