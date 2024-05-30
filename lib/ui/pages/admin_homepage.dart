// import 'package:aplikasi_bsu/pages/admin_acc_rewards_page.dart';
// import 'package:aplikasi_bsu/pages/manage_product_page.dart';
// import 'package:aplikasi_bsu/pages/admin_manage_user_page.dart';
// import 'package:aplikasi_bsu/pages/profile_page.dart';
// import 'package:aplikasi_bsu/pages/admin_view_trash_data.dart';
import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// import 'admin_notification_page.dart';

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
      backgroundColor: whiteColor,
      bottomNavigationBar: Container(
        height: 80,
        child: BottomAppBar(
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
                  icon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    child: Image.asset(
                      'assets/i_notifikasi.png',
                      width: 32,
                      height: 32,
                      color: _currentIndex == 1 ? blueColor : greyColor,
                    ),
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
          AdminHomePage(context),
          // AdminNotificationPage(),
        ],
      ),
    );
  }
}

Widget AdminHomePage(BuildContext context) {
  return Scaffold(
    backgroundColor: whiteColor,
    body: ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: edge),
          child: Container(
            margin: EdgeInsets.only(top: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin,',
                      style: blackTextStyle.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Doe',
                      style: blueTextStyle.copyWith(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ProfilePage(),
                    //   ),
                    // );
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/i_profile.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: edge),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ManageUsers(),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 170,
                          height: 208,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(vertical: 35),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Color(0xFFD63C3C),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFFF5E5E),
                                  ),
                                  child: Center(
                                    child: Image(
                                      width: 23.41,
                                      height: 32.11,
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          'assets/i_profile_white.png'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Kelola Data User',
                                  style: whiteTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => AccRewards(),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 170,
                          height: 208,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(vertical: 35),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Color(0xFFC51A76),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFFF5CB4),
                                  ),
                                  child: Center(
                                    child: Image(
                                      width: 44,
                                      height: 44,
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          'assets/i_blue_points.png'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Penukaran Poin',
                                  style: whiteTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DataSampah(),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 170,
                          height: 208,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(vertical: 35),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Color(0xFF9549D2),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFC987FF),
                                  ),
                                  child: Center(
                                    child: Image(
                                      width: 20,
                                      height: 42,
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          'assets/i_bottle_white.png'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Lihat Data Sampah',
                                  style: whiteTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                  softWrap: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ManageProductPage(),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 170,
                          height: 208,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.symmetric(vertical: 35),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Color(0xFF0043A8),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF6992EC),
                                  ),
                                  child: Center(
                                    child: Image(
                                      width: 32,
                                      height: 40,
                                      fit: BoxFit.contain,
                                      image: AssetImage(
                                          'assets/i_product_white.png'),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Kelola Data Barang',
                                  style: whiteTextStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
