import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _usernameController = TextEditingController();  // Mengganti email dengan username
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final response = await http.post(
      Uri.parse('http://10.60.64.19:5000/admin/login'),  // Mengarahkan ke endpoint admin login
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _usernameController.text,  // Mengirimkan username bukan email
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'token', value: data['access_token']);
      // Redirect ke halaman dashboard atau home setelah login berhasil
      Navigator.pushReplacementNamed(context, '/main-admin');
    } else {
      setState(() {
        _errorMessage = 'Login gagal, periksa username dan password.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,  // Mengubah email field menjadi username
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}
