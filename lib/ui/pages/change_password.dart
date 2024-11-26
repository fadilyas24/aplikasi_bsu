// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   @override
//   _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController oldPasswordController = TextEditingController();
//   TextEditingController newPasswordController = TextEditingController();
//   bool isLoading = false;

//   Future<void> _changePassword() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('jwt_token');

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('You are not logged in')),
//       );
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });

//     final url = Uri.parse('http://10.60.64.23:5000/user/change-password');
//     final response = await http.put(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({
//         'old_password': oldPasswordController.text,
//         'new_password': newPasswordController.text,
//       }),
//     );

//     setState(() {
//       isLoading = false;
//     });

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Password updated successfully')),
//       );
//     } else {
//       final responseData = json.decode(response.body);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${responseData['message']}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Change Password'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: oldPasswordController,
//                 decoration: InputDecoration(labelText: 'Old Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your old password';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: newPasswordController,
//                 decoration: InputDecoration(labelText: 'New Password'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a new password';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 32),
//               isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           _changePassword();
//                         }
//                       },
//                       child: Text('Change Password'),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> _changePassword() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are not logged in')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('http://192.168.1.9:5000/user/change-password');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'old_password': oldPasswordController.text,
        'new_password': newPasswordController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully')),
      );
    } else {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${responseData['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Ubah Password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password Baru',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Masukan password anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukan password baru';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Konfirmasi Password',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: oldPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Konfirmasi password anda',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Masukan konfirmasi password';
                    }
                    return null;
                  },
                ),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _changePassword();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Ubah Password',
                            style: whiteTextStyle,
                          ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
