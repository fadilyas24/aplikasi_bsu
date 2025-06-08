import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_bsu/shared/theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordController = TextEditingController();
  bool isLoading = false;

  // Fungsi untuk validasi password lama
  Future<void> _validateOldPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda belum login')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://bsuapp.space/api/user/change-password');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'old_password': oldPasswordController.text,
        'new_password': 'dummy_password', // sementara
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'] ?? 'Password salah')),
      );
    } else if (response.statusCode == 200) {
      _showNewPasswordDialog(token); // tampilkan form password baru
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan')),
      );
    }
  }

  // Fungsi untuk mengubah password
  Future<void> _changePassword(String newPassword, String token) async {
    final url = Uri.parse('https://bsuapp.space/api/user/change-password');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'old_password': oldPasswordController.text,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context); // tutup dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password berhasil diperbarui')),
      );
    } else {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: ${responseData['message']}')),
      );
    }
  }

  // Dialog untuk password baru
  void _showNewPasswordDialog(String token) {
    final TextEditingController newPassController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: whiteColor,
        title: Text('Masukkan Password Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: newPassController,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password Baru'),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: confirmPassController,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Konfirmasi Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batalkan', style: TextStyle(color: redColor)),
          ),
          TextButton(
            onPressed: () {
              if (newPassController.text != confirmPassController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password tidak cocok')),
                );
              } else if (newPassController.text.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password minimal 6 karakter')),
                );
              } else {
                _changePassword(newPassController.text, token);
              }
            },
            child: Text(
              'Simpan',
              style: TextStyle(color: blueColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text('Ubah Password',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password Lama',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 8),
            TextFormField(
              controller: oldPasswordController,
              decoration: InputDecoration(
                hintText: 'Masukkan password lama anda',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              obscureText: true,
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _validateOldPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Lanjut', style: whiteTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
