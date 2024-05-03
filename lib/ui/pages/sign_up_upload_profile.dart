import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:flutter/material.dart';

import '../widget/buttons.dart';
import 'home_page.dart';

class SignUpSetProfilePage extends StatelessWidget {
  const SignUpSetProfilePage({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightColor,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/i_upload.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Bintang Preciosa',
                  style: blackTextStyle.copyWith(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomFilledButton(
                  title: 'Daftar',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
