import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/widget/buttons.dart';
import 'package:aplikasi_bsu/ui/widget/forms.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    const String url =
        'http://192.168.1.8:5000/user/login'; // Ubah sesuai URL API Flask Anda

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String token = responseData['access_token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_id', responseData['user_id'].toString());

      // await prefs.setString('full_name', responseData['full_name'] ?? '');
      // await prefs.setString('user_address', responseData['user_address'] ?? '');
      // await prefs.setString('phone_number', responseData['phone_number'] ?? '');

      print('Login successful: ${responseData}');
      // Simpan token akses dan data pengguna ke dalam storage (shared preferences atau lainnya)
      Navigator.pushNamed(context, '/main-home');
    } else if (response.statusCode == 401) {
      print('Failed to login: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login gagal: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: lightColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: edge),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/admin-login');
                },
                child: Container(
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: blueColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Center(
                            child: Icon(Icons.person_outline_outlined,
                                color: blueColor)),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Admin',
                        style: regularTextStyle.copyWith(
                            color: whiteColor, fontSize: 14),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            width: 200,
            height: 145,
            margin: EdgeInsets.only(top: 30, bottom: 30),
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/logo_bsu.png')),
            ),
          ),
          Text(
            'Ayo Masuk &\nSetorkan Sampahmu',
            style: blackTextStyle.copyWith(
                fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // EMAIL INPUT
                CustomFormField(
                  title: 'Email',
                  formHintText: 'Masukkan email anda',
                  controller: emailController,
                ),
                SizedBox(
                  height: 16,
                ),
                // PASSWORD INPUT
                CustomFormField(
                  title: 'Password',
                  formHintText: 'Masukkan password Anda',
                  obscureText: true,
                  controller: passwordController,
                ),
                SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomTextButton(
                    title: 'Lupa Password',
                    width: 110,
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 30),
                CustomFilledButton(
                  title: 'Masuk',
                  onPressed: () async {
                    await loginUser(
                      context,
                      emailController.text,
                      passwordController.text,
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum memiliki akun?',
                      style: regularTextStyle,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/sign-up');
                        },
                        child: Text(
                          'Daftar',
                          style: regularTextStyle.copyWith(
                              color: blueColor, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
