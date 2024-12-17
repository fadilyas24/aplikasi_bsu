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
        Uri.parse('http://10.60.40.104:5000/admin/login'),
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
      backgroundColor: const Color.fromARGB(255, 245, 247, 248),
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
                  Text(
                    'Admin Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 107, 186),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kelola sistem pengelolaan sampah Anda',
                    style: TextStyle(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 0, 107, 186)),
                  ),
                ],
              ),
              SizedBox(height: 40),

              // Username input
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person,
                      color: Color.fromARGB(255, 0, 107, 186)),
                  labelText: 'Username',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 0, 107, 186)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 0, 107, 186)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 0, 107, 186)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Password input
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.lock, color: Color.fromARGB(255, 0, 107, 186)),
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 0, 107, 186)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 0, 107, 186)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 0, 107, 186)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 30),

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
                        backgroundColor: Color.fromARGB(255, 0, 107, 186),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
              SizedBox(height: 20),

              // Error message
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
