import 'package:aplikasi_bsu/ui/pages/admin_manage_product_page.dart';
import 'package:aplikasi_bsu/ui/pages/admin_view_trash_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:aplikasi_bsu/shared/theme.dart';
import '../widget/admin_menu_card.dart';
import 'admin_validation_page.dart';

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
      _token = prefs.getString('token');

      if (_token == null) {
        setState(() {
          _errorMessage = 'Token tidak ditemukan, silakan login kembali.';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('https://bsuapp.space/api/admin/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
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
                    'assets/i_validation.png',
                    width: 32,
                    height: 32,
                    color: _currentIndex == 1 ? blueColor : greyColor,
                  ),
                  label: 'Validasi',
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
                    AdminValidationPage(),
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
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/admin-profile');
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 55),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: blueColor.withOpacity(0.15),
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: blueColor,
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _adminData?['username'] ?? 'Unknown',
                        style: blackTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Admin',
                        style: greyTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
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
                  title: 'Kelola Lokasi',
                  iconUrl: 'assets/i_location_admin.png',
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminManageProductPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
