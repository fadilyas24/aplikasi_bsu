import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/widget/forms.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://bsuapp.space/api/admin/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        print('Token yang disimpan: ${data['access_token']}');
        await prefs.setString('token', data['access_token']);

        // Debugging: Log token
        print('Token yang diterima: ${data['access_token']}');
        // Simpan token JWT ke SharedPreferences
        await prefs.setString('token', data['access_token']);

        // Arahkan ke halaman utama admin
        Navigator.pushReplacementNamed(context, '/main-admin');
      } else {
        setState(() {
          _errorMessage = 'Login gagal, periksa username dan password.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan. Coba lagi nanti.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header with logo and title
              Column(
                children: [
                  Image.asset(
                    'assets/logo_bsu.png', // Masukkan path gambar ikon pengelolaan sampah
                    height: 100,
                  ),
                  SizedBox(height: 16),
                  Text('Admin Login',
                      style: blackTextStyle.copyWith(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Kelola sistem pengelolaan sampah Anda',
                      style: blackTextStyle),
                ],
              ),
              SizedBox(height: 40),

              // Username input
              CustomFormField(
                title: 'Username',
                formHintText: 'Masukkan Username anda',
                controller: _usernameController,
              ),
              SizedBox(
                height: 16,
              ),
              // PASSWORD INPUT
              CustomFormField(
                title: 'Password',
                formHintText: 'Masukkan password Anda',
                obscureText: true,
                controller: _passwordController,
              ),
              SizedBox(
                height: 16,
              ),

              // Login button
              _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        backgroundColor: blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: whiteColor),
                      ),
                    ),
              SizedBox(height: 20),

              // Error message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: redColor, fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
