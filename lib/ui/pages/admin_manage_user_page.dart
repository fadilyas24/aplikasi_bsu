import 'dart:convert';
import 'package:aplikasi_bsu/ui/widget/admin_user_card.dart';
import 'package:aplikasi_bsu/ui/widget/forms.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/theme.dart';

class AdminManageUser extends StatefulWidget {
  const AdminManageUser({super.key});

  @override
  _AdminManageUserState createState() => _AdminManageUserState();
}

class _AdminManageUserState extends State<AdminManageUser> {
  Map<String, dynamic>? adminData;
  List<dynamic> _users = [];
  List<dynamic> filteredUsers = []; // Daftar pengguna setelah difilter
  bool _isLoading = true;
  String _errorMessage = '';
  String? _token;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _getAdminData();
    _fetchUsers();
  }

  Future<void> _getAdminData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token'); // Ambil token dari SharedPreferences
      print(
          'Token yang diambil: $_token'); // Tambahkan log untuk memeriksa token

      if (_token == null) {
        setState(() {
          _errorMessage = 'Token tidak ditemukan, silakan login kembali.';
          _isLoading = false;
        });
        return;
      }

      // Panggil API untuk mendapatkan data admin
      final response = await http.get(
        Uri.parse('http://192.168.1.9:5000/admin/profile'),
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

  Future<void> _fetchUsers() async {
    try {
      String? token = await getToken();
      if (token == null) throw Exception('Token is missing');

      final response = await http.get(
        Uri.parse('http://192.168.1.9:5000/users'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> userList = jsonDecode(response.body);
        setState(() {
          _users = userList;
          filteredUsers =
              userList; // Inisialisasi daftar pengguna yang ditampilkan
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          _errorMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        Navigator.pushReplacementNamed(context, '/');
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data pengguna.';
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

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = _users
          .where((user) =>
              user['full_name']?.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Nasabah'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: edge),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : ListView(
                    children: [
                      const CustomFormField(
                        title: '',
                        formHintText: 'Cari Nasabah',
                      ),
                      const SizedBox(height: 20),
                      ..._users.map((user) {
                        return AdminUserCard(
                          name: user['full_name'] ?? 'Nama tidak tersedia',
                          email: user['email'] ?? 'Email tidak tersedia',
                          onTap: () {
                            // Navigasi ke detail user jika diperlukan
                          },
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                    ],
                  ),
      ),
    );
  }
}
