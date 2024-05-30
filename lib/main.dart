import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/pages/activity_pages.dart';
import 'package:aplikasi_bsu/ui/pages/edit_profile.dart';
import 'package:aplikasi_bsu/ui/pages/home_page.dart';
import 'package:aplikasi_bsu/ui/pages/main_page.dart';
import 'package:aplikasi_bsu/ui/pages/notification_page.dart';
import 'package:aplikasi_bsu/ui/pages/pin_page.dart';
import 'package:aplikasi_bsu/ui/pages/poin_redeem_success_page.dart';
import 'package:aplikasi_bsu/ui/pages/profile_page.dart';
import 'package:aplikasi_bsu/ui/pages/redeem_poin_page.dart';
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
      theme: ThemeData(
        scaffoldBackgroundColor: lightColor,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: blackColor),
          backgroundColor: lightColor,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      routes: {
        '/': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/main-home': (context) => MainPage(),
        '/notification': (context) => NotificationPage(),
        '/profile': (context) => ProfilePage(),
        '/activity': (context) => ActivtyPages(),
        '/edit-profile': (context) => EditProfilePage(),
        '/redeem-poin': (context) => RedeemPointPage(),
        '/pin': (context) => PinPage(),
        '/redeem-success':(context) => PoinRedeemSuccessPage(),
      },
    );
  }
}
