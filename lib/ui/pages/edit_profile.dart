import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  File? _profileImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('full_name') ?? '';
    _addressController.text = prefs.getString('user_address') ?? '';
    _phoneController.text = prefs.getString('phonenum') ?? '';
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
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

    Map<String, dynamic> updatedData = {};

    if (_nameController.text.isNotEmpty &&
        _nameController.text != prefs.getString('full_name')) {
      updatedData['full_name'] = _nameController.text;
    }

    if (_addressController.text.isNotEmpty &&
        _addressController.text != prefs.getString('user_address')) {
      updatedData['user_address'] = _addressController.text;
    }

    if (_phoneController.text.isNotEmpty &&
        _phoneController.text != prefs.getString('phonenum')) {
      updatedData['phonenum'] = _phoneController.text;
    }

    if (_profileImage != null) {
      final bytes = await _profileImage!.readAsBytes();
      updatedData['profile_picture'] = base64Encode(bytes);
    }

    if (updatedData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada perubahan yang dilakukan')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.put(
      Uri.parse('http://10.60.64.39:5000/user/update'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': userId,
        ...updatedData,
      }),
    );

    if (response.statusCode == 200) {
      updatedData.forEach((key, value) {
        prefs.setString(key, value.toString());
      });

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
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : AssetImage('assets/img_profile.png')
                                  as ImageProvider,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextButton(
                        title: 'Unggah Foto',
                        onPressed: _pickImage,
                      ),
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
