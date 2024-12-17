import 'package:aplikasi_bsu/ui/pages/admin_view_trash_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:aplikasi_bsu/shared/theme.dart';
import '../widget/admin_menu_card.dart';
import '../widget/user_profile_card.dart';
import 'admin_notification_page.dart';

class MainAdmin extends StatefulWidget {
  const MainAdmin({Key? key});

  @override
  State<MainAdmin> createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  int _currentIndex = 0;
  final numberFormat = NumberFormat('#.#');
  String? _token;
  Map<String, dynamic>? _adminData;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getAdminData();
  }

  Future<void> _getAdminData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token'); // Ambil token dari SharedPreferences

      if (_token == null) {
        setState(() {
          _errorMessage = 'Token tidak ditemukan, silakan login kembali.';
          _isLoading = false;
        });
        return;
      }

      // Panggil API untuk mendapatkan data admin
      final response = await http.get(
        Uri.parse('http://10.60.40.104:5000/admin/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token', // Sertakan token JWT di header
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _adminData = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data admin. Silakan coba lagi.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : IndexedStack(
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
                  name: _adminData?['username'] ?? 'Unknown',
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrashPage()),
                    );
                  },
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
