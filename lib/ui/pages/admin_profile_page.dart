import 'package:aplikasi_bsu/ui/widget/profile_item.dart';
import 'package:aplikasi_bsu/ui/widget/user_profile_card.dart';
import 'package:flutter/material.dart';

import '../../shared/theme.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Profil Saya',
        ),
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
                    email: 'admin'),
              ],
            ),
          ),
          const SizedBox(height: 25),
          // ProfileItem(
          //   title: 'Edit Profil',
          //   iconUrl: 'assets/i_profile_bold.png',
          //   iconColor: blueColor,
          //   onTap: () async {
          //     if (await Navigator.pushNamed(context, '/pin') == true) {
          //       Navigator.pushNamed(context, '/edit-profile');
          //     }
          //   },
          // ),
          // ProfileItem(
          //   title: 'Pin Saya',
          //   iconUrl: 'assets/i_pin.png',
          //   iconColor: blueColor,
          // ),
          ProfileItem(
            title: 'Ubah Bahasa',
            iconUrl: 'assets/i_language.png',
            iconColor: blueColor,
          ),
          // ProfileItem(
          //   title: 'Ubah Password',
          //   iconUrl: 'assets/i_password.png',
          //   iconColor: blueColor,
          // ),
          ProfileItem(
            title: 'Pusat Bantuan',
            iconUrl: 'assets/i_help_center.png',
            iconColor: blueColor,
          ),
          ProfileItem(
            title: 'Logout',
            iconUrl: 'assets/i_logout.png',
            iconColor: whiteColor,
            color: redColor,
            textColor: whiteColor,
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
