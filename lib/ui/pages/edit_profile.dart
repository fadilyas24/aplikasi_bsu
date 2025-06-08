import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/theme.dart';
import '../widget/buttons.dart';
import '../widget/forms.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfileFromAPI();
  }

  Future<void> _fetchUserProfileFromAPI() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token tidak ditemukan')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse('https://bsuapp.space/api/user-sessions'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        _nameController.text = data['full_name'] ?? '';
        _addressController.text = data['user_address'] ?? '';
        _phoneController.text =
            data['phonenum'] ?? ''; // Tetap kosong seperti permintaan
        _emailController.text = data['email'] ?? '';

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data profil')),
      );
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    String? userId = prefs.getString('user_id');

    if (token == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token atau ID pengguna hilang')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    Map<String, dynamic> updatedData = {
      'user_id': userId,
      'full_name': _nameController.text,
      'user_address': _addressController.text,
      'email': _emailController.text,
    };

    if (_phoneController.text.isNotEmpty) {
      updatedData['phonenum'] = _phoneController.text;
    }

    final response = await http.put(
      Uri.parse('https://bsuapp.space/api/user/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedData),
    );

    if (response.statusCode == 200) {
      // Update ke SharedPreferences juga jika ingin
      prefs.setString('full_name', _nameController.text);
      prefs.setString('user_address', _addressController.text);
      if (_phoneController.text.isNotEmpty) {
        prefs.setString('phonenum', _phoneController.text);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil berhasil diperbarui')),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: blackColor),
        title: Text('Edit Profil'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.symmetric(horizontal: edge),
              children: [
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomFormField(
                        title: 'Nama Lengkap',
                        formHintText: 'Masukkan nama lengkap anda',
                        controller: _nameController,
                      ),
                      SizedBox(height: 16),
                      CustomFormField(
                        title: 'Email',
                        formHintText: 'Masukkan email anda',
                        controller: _emailController,
                      ),
                      SizedBox(height: 30),
                      CustomFormField(
                        title: 'Alamat',
                        formHintText: 'Masukkan alamat anda',
                        controller: _addressController,
                      ),
                      SizedBox(height: 16),
                      CustomFormField(
                        title: 'No Handphone',
                        formHintText: 'Masukkan no handphone anda',
                        controller: _phoneController,
                      ),
                      SizedBox(height: 30),
                      CustomFilledButton(
                        title: 'Simpan',
                        onPressed: _saveProfile,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
