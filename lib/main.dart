import 'package:aplikasi_bsu/ui/pages/home_page.dart';
import 'package:aplikasi_bsu/ui/pages/main_page.dart';
import 'package:aplikasi_bsu/ui/pages/notification_page.dart';
import 'package:aplikasi_bsu/ui/pages/profile_page.dart';
import 'package:aplikasi_bsu/ui/pages/sign_in_page.dart';
import 'package:aplikasi_bsu/ui/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/main-home': (context) => MainPage(),
        '/notification': (context) => NotificationPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
