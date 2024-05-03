import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/pages/sign_in_page.dart';
import 'package:flutter/material.dart';

import '../widget/buttons.dart';
import '../widget/forms.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

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
            margin: EdgeInsets.only(
              top: 50,
              bottom: 50,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/logo_bsu.png')),
            ),
          ),
          Text(
            'Ayo Daftar &\nSetorkan Sampahmu',
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
                //NAME INPUT
                CustomFormField(
                  title: 'Nama Lengkap',
                  formHintText: 'Masukkan nama lengkap anda',
                ),
                SizedBox(
                  height: 16,
                ),
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
                  height: 16,
                ),
                //KONFIRMASI PASSWORD INPUT
                // CustomFormField(
                //   title: 'Konfirmasi Password',
                //   formHintText: 'Konfirmasi password Anda',
                //   obscureText: true,
                // ),
                SizedBox(
                  height: 30,
                ),
                CustomFilledButton(
                  title: 'Lanjut',
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign-up-set-profile');
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah memiliki akun?',
                      style: regularTextStyle,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()));
                      },
                      child: Text(
                        'Masuk',
                        style: regularTextStyle.copyWith(
                            color: blueColor, fontWeight: FontWeight.bold),
                      ),
                    ),
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
