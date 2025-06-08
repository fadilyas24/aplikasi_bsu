import 'package:aplikasi_bsu/ui/pages/change_password.dart';
import 'package:aplikasi_bsu/ui/widget/profile_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_bsu/ui/pages/edit_profile.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    String? token = await getToken();

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('https://bsuapp.space/api/user-sessions'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          setState(() {
            userProfile = json.decode(response.body);
            isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat profil')),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token tidak ditemukan')),
      );
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> _refreshProfile() async {
    await _fetchUserProfile();
  }

  Future<void> logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: blueColor, size: 60),
            SizedBox(height: 10),
            Text(
              'Logout Berhasil',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Anda telah keluar dari akun Anda.'),
          ],
        ),
      ),
    );

    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop(); // tutup dialog
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: whiteColor,
        title: Text('Anda telah keluar'),
        content: Text('Anda berhasil keluar dari aplikasi.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Text('OK', style: TextStyle(color: blueColor)),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: whiteColor,
            title: Text('Konfirmasi Logout'),
            content: Text('Apakah Anda ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Tidak', style: TextStyle(color: redColor)),
              ),
              TextButton(
                onPressed: () {
                  _logout();
                },
                child: Text('Iya', style: TextStyle(color: blueColor)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: lightColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Profil Saya', style: TextStyle(color: whiteColor)),
          backgroundColor: blueColor,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: edge),
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: whiteColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProfile?['full_name'] ?? 'Nama tidak ditemukan',
                          style: blackTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          userProfile?['email'] ?? 'Email tidak ditemukan',
                          style: greyTextStyle.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  ProfileItem(
                    title: 'Edit Profil',
                    iconUrl: 'assets/i_profile_bold.png',
                    iconColor: blueColor,
                    onTap: () async {
                      final bool? result = await Navigator.push<bool?>(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()),
                      );
                      if (result == true) {
                        _refreshProfile();
                      }
                    },
                  ),
                  ProfileItem(
                    title: 'Ubah Bahasa',
                    iconUrl: 'assets/i_language.png',
                    iconColor: blueColor,
                  ),
                  ProfileItem(
                    title: 'Ubah Password',
                    iconUrl: 'assets/i_password.png',
                    iconColor: blueColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen()),
                      );
                    },
                  ),
                  ProfileItem(
                    title: 'Pusat Bantuan',
                    iconUrl: 'assets/i_help_center.png',
                    iconColor: blueColor,
                  ),
                  ProfileItem(
                    title: 'Logout',
                    iconUrl: 'assets/i_logout.png',
                    iconColor: whiteColor,
                    color: redColor,
                    textColor: whiteColor,
                    onTap: () async {
                      await logoutUser(context);
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
      ),
    );
  }
}
