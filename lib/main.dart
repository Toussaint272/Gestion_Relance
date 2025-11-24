import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart'; // ✅ Ampidiro io
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      // ✅ Wrapper manodidina ny MaterialApp
      child: MaterialApp(
        title: 'Gestion Défaillants DGI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(), // 🚀 Page de départ
      ),
    );
  }
}
