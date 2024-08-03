import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/pages/admin_notification_page.dart';
import 'package:aplikasi_bsu/ui/widget/admin_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widget/user_profile_card.dart';

class MainAdmin extends StatefulWidget {
  const MainAdmin({Key? key});

  @override
  State<MainAdmin> createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  int _currentIndex = 0;
  final numberFormat = NumberFormat('#.#');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        child: BottomAppBar(
          padding: EdgeInsets.zero,
          color: whiteColor,
          child: Material(
            shadowColor: greyColor,
            elevation: 30,
            child: BottomNavigationBar(
              elevation: 200,
              backgroundColor: whiteColor,
              selectedItemColor: blueColor,
              unselectedItemColor: greyColor,
              selectedLabelStyle:
                  blackTextStyle.copyWith(fontSize: 12, color: blueColor),
              unselectedLabelStyle:
                  blackTextStyle.copyWith(fontSize: 12, color: greyColor),
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset('assets/i_home.png',
                      width: 32,
                      height: 32,
                      color: _currentIndex == 0 ? blueColor : greyColor),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/i_notification.png',
                    width: 32,
                    height: 32,
                    color: _currentIndex == 1 ? blueColor : greyColor,
                  ),
                  label: 'Notifikasi',
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          adminHomePage(context),
          AdminNotificationPage(),
        ],
      ),
    );
  }

  Widget adminHomePage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: edge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              top: 55,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
            ),
            child: Column(
              children: [
                UserProfileCard(
                  imgUrl: 'assets/img_profile.png',
                  name: 'Jack Sparrow',
                  email: 'Admin',
                  onTap: () {
                    Navigator.pushNamed(context, '/admin-profile');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.75,
              children: [
                AdminMenuCard(
                  title: 'Kelola Nasabah',
                  iconUrl: 'assets/i_profile_bold.png',
                  onTap: () {
                    Navigator.pushNamed(context, '/admin-manage-user');
                  },
                ),
                AdminMenuCard(
                  title: 'Penukaran Poin',
                  iconUrl: 'assets/i_coin.png',
                  onTap: () {},
                ),
                AdminMenuCard(
                  title: 'Lihat Data Sampah',
                  iconUrl: 'assets/i_trashbag.png',
                  onTap: () {},
                ),
                AdminMenuCard(
                  title: 'Kelola Stok Produk',
                  iconUrl: 'assets/i_product.png',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
