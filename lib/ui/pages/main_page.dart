import 'package:aplikasi_bsu/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme.dart';
import 'home_page.dart';
import 'notification_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentMenu = 0;

  Widget bottomNavigationBar() {
    switch (currentMenu) {
      case 0:
        return const HomePage();
      case 1:
        return const NotificationPage();
      case 2:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        child: BottomAppBar(
          padding: EdgeInsets.zero,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            backgroundColor: whiteColor,
            selectedItemColor: blueColor,
            unselectedItemColor: greyColor,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: blueTextStyle.copyWith(
              fontSize: 12,
              fontWeight: semiBold,
            ),
            unselectedLabelStyle: blueTextStyle.copyWith(
              fontSize: 12,
              fontWeight: semiBold,
            ),
            currentIndex: currentMenu,
            onTap: (value) {
              debugPrint('Current Menu ${value}');
              setState(() {
                currentMenu = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/i_home.png',
                  width: 30,
                  color: currentMenu == 0 ? blueColor : greyColor,
                ),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/i_notification.png',
                  width: 30,
                  color: currentMenu == 1 ? blueColor : greyColor,
                ),
                label: 'Notifikasi',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/i_profile.png',
                  width: 30,
                  color: currentMenu == 2 ? blueColor : greyColor,
                ),
                label: 'Profil Saya',
              ),
            ],
          ),
        ),
      ),
      body: bottomNavigationBar(),
    );
  }
}
