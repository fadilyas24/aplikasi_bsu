import 'dart:convert';
import 'package:aplikasi_bsu/ui/pages/admin_user_data.dart';
import 'package:aplikasi_bsu/ui/widget/admin_user_card.dart';
// import 'package:aplikasi_bsu/ui/widget/forms.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aplikasi_bsu/shared/theme.dart';

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
        Uri.parse('https://bsuapp.space/api/admin/profile'),
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
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Token is missing');

      final response = await http.get(
        Uri.parse('https://bsuapp.space/api/users'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> userList = jsonDecode(response.body);
        setState(() {
          _users = userList;
          filteredUsers = userList;
          _isLoading = false;
        });
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

  void _deleteUser(String userId) async {
  try {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('https://bsuapp.space/api/users/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    debugPrint("Status Code: ${response.statusCode}");
    debugPrint("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        _users.removeWhere((user) => user['user_id'].toString() == userId);
        filteredUsers = _users;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nasabah berhasil dihapus')),
      );
    } else {
      throw Exception('Gagal menghapus nasabah');
    }
  } catch (e) {
    debugPrint("Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan: $e')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: whiteColor),
        backgroundColor: blueColor,
        title: Text('Kelola Nasabah', style: TextStyle(color: whiteColor)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: edge, vertical: edge),
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Cari Nasabah',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _onSearch,
                    ),
                    const SizedBox(height: 26),
                    ...filteredUsers.map((user) {
  return AdminUserCard(
    name: user['full_name'] ?? 'Nama tidak tersedia',
    email: user['email'] ?? 'Email tidak tersedia',
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminUserData(userData: user),
        ),
      );
    },
    onDelete: () {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Hapus Nasabah'),
          content: Text('Yakin ingin menghapus nasabah ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteUser(user['user_id'].toString());
              },
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    },
  );
}).toList()

                  ],
                ),
    );
  }
}
