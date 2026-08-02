import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/rat_service.dart';

void main() => runApp(const RATFPT());

class RATFPT extends StatelessWidget {
  const RATFPT({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RATService(),
      child: MaterialApp(
        title: 'FXTP RAT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0a0a12),
          primaryColor: const Color(0xFF7c5cfc),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF7c5cfc),
            secondary: Color(0xFF00f0ff),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0a0a12),
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
