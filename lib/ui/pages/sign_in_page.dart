import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/widget/buttons.dart';
import 'package:aplikasi_bsu/ui/widget/forms.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: edge),
        children: [
          Container(
            width: 161,
            height: 105,
            margin: EdgeInsets.only(top: 50, bottom: 120),
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
                //EMAIL INPUT
                CustomFormField(
                  title: 'Email',
                  formHintText: 'Masukkan email anda',
                ),
                SizedBox(
                  height: 16,
                ),
                //PASSWORD INPUT
                CustomFormField(
                  title: 'Password',
                  formHintText: 'Masukkan password Anda',
                  obscureText: true,
                ),
                SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Lupa Password',
                    style: blueTextStyle.copyWith(fontSize: 14),
                  ),
                ),
                SizedBox(height: 30),
                CustomFilledButton(
                  title: 'Masuk',
                  onPressed: () {
                    Navigator.pushNamed(context, '/main-home');
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
