import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/giris.dart'; 

void main() {
  runApp(const Cayapp());
}

class Cayapp extends StatelessWidget {
  const Cayapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cayapp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Giris(),
    );
  }
}
