import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../shared/theme.dart';
import '../widget/profile_item.dart';
import '../widget/user_profile_card.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  Map<String, dynamic>? adminData;
  String _errorMessage = '';
  bool _isLoading = true;
  String? _token;

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
        Uri.parse('http://192.168.1.8:5000/admin/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token', // Sertakan token JWT di header
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          adminData = jsonDecode(response.body);
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

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data
    Navigator.pushReplacementNamed(context, '/'); // Redirect ke login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Profil Saya'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView(
                  padding: EdgeInsets.symmetric(horizontal: edge),
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                        top: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: whiteColor,
                      ),
                      child: Column(
                        children: [
                          UserProfileCard(
                            imgUrl: 'assets/img_profile.png',
                            name: adminData?['username'] ?? 'Unknown',
                            email: adminData?['email'] ?? 'Admin',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    ProfileItem(
                      title: 'Ubah Bahasa',
                      iconUrl: 'assets/i_language.png',
                      iconColor: blueColor,
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
                      onTap: _logout,
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
    );
  }
}
