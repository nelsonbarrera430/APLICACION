import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import necesario
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necesario antes de código async
  await initializeDateFormatting('es'); // Inicializa los datos locales para DateFormat

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appwrite Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const LoginPage(),
    );
  }
}
