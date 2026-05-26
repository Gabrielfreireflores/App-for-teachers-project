import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/avaliacoes_provider.dart';
import 'screens/loading_screen.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<AvaliacoesProvider>(
          create: (_) => AvaliacoesProvider(),
        ),
      ],
      child: const MyApp(),
    ) as Widget,
  );
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
  fontFamily: 'Roboto',
  scaffoldBackgroundColor: const Color(0xFFF5F7F9),

  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF0F3D3E),
    primary: const Color(0xFF0F3D3E),
    secondary: const Color(0xFFA8E6CF),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: Colors.black,
  ),

  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Colors.black87,
    ),
  ),
),
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}