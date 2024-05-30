import 'package:flutter/material.dart';
import '../../shared/theme.dart';
import '../widget/buttons.dart';
import '../widget/forms.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

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
      body: ListView(
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
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      title: 'Alamat',
                      formHintText: 'Masukkan alamat anda',
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CustomFormField(
                      title: 'No Handphone',
                      formHintText: 'Masukkan no handphone anda',
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(height: 30),
                    CustomFilledButton(
                      title: 'Simpan',
                      onPressed: () {
                        Navigator.pushNamed(context, '/main-home');
                      },
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
