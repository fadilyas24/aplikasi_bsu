import 'package:aplikasi_bsu/ui/pages/home_page.dart';
import 'package:aplikasi_bsu/ui/pages/sign_in_page.dart';
import 'package:aplikasi_bsu/ui/pages/sign_up_page.dart';
import 'package:aplikasi_bsu/ui/pages/sign_up_upload_profile.dart';
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
        '/sign-up-set-profile': (context) => SignUpSetProfilePage(),
      },
    );
  }
}
