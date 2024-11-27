import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('full_name') ?? '';
      _addressController.text = prefs.getString('user_address') ?? '';
      _phoneController.text = prefs.getString('phonenum') ?? '';
    });
  }

  Future<void> _saveProfile() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    String? userId =
        prefs.getString('user_id'); // Pastikan 'user_id' disimpan saat login

    if (token == null || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token atau ID pengguna hilang')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.put(
      Uri.parse('http://192.168.1.9:5000/user/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': userId,
        'full_name': _nameController.text,
        'user_address': _addressController.text,
        'phonenum': _phoneController.text,
      }),
    );

    if (response.statusCode == 201) {
      // Update SharedPreferences dengan data yang baru
      await prefs.setString('full_name', _nameController.text);
      await prefs.setString('user_address', _addressController.text);
      await prefs.setString('phonenum', _phoneController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profil berhasil diperbarui')),
      );

      // Update halaman profil setelah data diupdate
      Navigator.pop(context,
          true); // Mengirimkan nilai true untuk menandakan update sukses
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
        title: Text(
          'Edit Profil',
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.symmetric(
                horizontal: edge,
              ),
              children: [
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: whiteColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/img_profile.png',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextButton(title: 'Unggah Foto'),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomFormField(
                            title: 'Nama Lengkap',
                            formHintText: 'Masukkan nama lengkap anda',
                            controller: _nameController,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CustomFormField(
                            title: 'Alamat',
                            formHintText: 'Masukkan alamat anda',
                            controller: _addressController,
                          ),
                          SizedBox(
                            height: 16,
                          ),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
