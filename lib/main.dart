import 'package:flutter/material.dart';
import 'package:joub_jum/pages/auth_pages/phone_num.dart';
import 'package:joub_jum/pages/home.dart';
import 'package:joub_jum/pages/map_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Starter Template',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const PhoneNum(),
    );
  }
}