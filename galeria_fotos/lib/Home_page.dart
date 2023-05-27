import 'package:flutter/material.dart';
import 'galeria.dart';

class Home_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Galeria(),
    );
  }
}
