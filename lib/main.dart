// lib/main.dart

import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/add_student_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(const StudentDirectoryApp());
}

class StudentDirectoryApp extends StatelessWidget {
  const StudentDirectoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Directory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          brightness: Brightness.light,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/add': (context) => const AddStudentPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
