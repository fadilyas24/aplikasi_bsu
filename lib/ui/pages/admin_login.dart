// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class AdminLoginPage extends StatefulWidget {
//   @override
//   _AdminLoginPageState createState() => _AdminLoginPageState();
// }

// class _AdminLoginPageState extends State<AdminLoginPage> {
//   final TextEditingController _usernameController = TextEditingController();  // Mengganti email dengan username
//   final TextEditingController _passwordController = TextEditingController();
//   final FlutterSecureStorage _storage = FlutterSecureStorage();
//   bool _isLoading = false;
//   String _errorMessage = '';

//   Future<void> _login() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = '';
//     });

//     final response = await http.post(
//       Uri.parse('http://192.168.1.9:5000/admin/login'),  // Mengarahkan ke endpoint admin login
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'username': _usernameController.text,  // Mengirimkan username bukan email
//         'password': _passwordController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       await _storage.write(key: 'token', value: data['access_token']);
//       // Redirect ke halaman dashboard atau home setelah login berhasil
//       Navigator.pushReplacementNamed(context, '/main-admin');
//     } else {
//       setState(() {
//         _errorMessage = 'Login gagal, periksa username dan password.';
//       });
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Admin Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _usernameController,  // Mengubah email field menjadi username
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _login,
//                     child: Text('Login'),
//                   ),
//             if (_errorMessage.isNotEmpty) ...[
//               SizedBox(height: 20),
//               Text(_errorMessage, style: TextStyle(color: Colors.red)),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
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
      Uri.parse('http://192.168.1.9:5000/admin/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'token', value: data['access_token']);
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
