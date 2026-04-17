import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: const TextTheme(
  headlineSmall: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Color(0xFF0F3D3E),
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    color: Colors.black87,
  ),
),
  primaryColor: const Color(0xFF0F3D3E),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F3D3E),
    foregroundColor: Colors.white,
    centerTitle: true,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFA8E6CF),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
),
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}