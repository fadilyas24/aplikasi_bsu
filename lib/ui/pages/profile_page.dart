import 'package:aplikasi_bsu/ui/widget/profile_item.dart';
import 'package:aplikasi_bsu/ui/widget/user_profile_card.dart';
import 'package:flutter/material.dart';

import '../../shared/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: lightColor,
        title: Text(
          'Profil Saya',
          style: blackTextStyle.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: edge,
        ),
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(
              top: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
            ),
            child: const Column(
              children: [
                UserProfileCard(
                    imgUrl: 'assets/img_profile.png',
                    name: 'Jack Sparrow',
                    email: 'jackseparo@gmail.com'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const ProfileItem(
            title: 'Ubah Bahasa',
            iconUrl: 'assets/i_language.png',
          ),
          const ProfileItem(
            title: 'Ubah Password',
            iconUrl: 'assets/i_password.png',
          ),
          const ProfileItem(
              title: 'Pusat Bantuan', iconUrl: 'assets/i_help_center.png'),
          ProfileItem(
            title: 'Logout',
            iconUrl: 'assets/i_logout.png',
            color: redColor,
            textColor: whiteColor,
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
