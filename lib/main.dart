import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/booking_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: '기차 예매',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
          ),
         darkTheme: ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Colors.black, // grey[900]에서 pure black으로 변경
  primaryColor: Colors.purple,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black, // grey[900]에서 pure black으로 변경
    foregroundColor: Colors.white,
    elevation: 0,
  ),
),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomePage(),
        );
      },
    );
  }
}