import 'package:flutter/material.dart';

import '../../shared/theme.dart';
import '../widget/buttons.dart';

class AdminAddSavingsSuccessPage extends StatelessWidget {
  const AdminAddSavingsSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: edge),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Tambah Tabungan Berhasil',
                  style: blackTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/i_green_check.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: whiteColor,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Rincian Tabungan',
                            style: blackTextStyle.copyWith(
                                fontSize: 14, fontWeight: bold),
                          ),
                          Spacer(),
                          Text(
                            '31 Mei 2024',
                            style: greyTextStyle.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            'Plastik',
                            style: regularTextStyle.copyWith(fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            '10 Poin',
                            style: blueTextStyle.copyWith(
                                fontSize: 14, fontWeight: medium),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Kertas',
                            style: regularTextStyle.copyWith(fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            '30 Poin',
                            style: blueTextStyle.copyWith(
                                fontSize: 14, fontWeight: medium),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Minyak Jelantah',
                            style: regularTextStyle.copyWith(
                                fontSize: 14, fontWeight: medium),
                          ),
                          Spacer(),
                          Text(
                            '0 Poin',
                            style: blueTextStyle.copyWith(
                                fontSize: 14, fontWeight: medium),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            'Kaca',
                            style: regularTextStyle.copyWith(fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            '0 Poin',
                            style: blueTextStyle.copyWith(
                                fontSize: 14, fontWeight: medium),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: blackTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '40 Poin',
                            style: blueTextStyle.copyWith(
                                fontSize: 14, fontWeight: medium),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 130,
                ),
                CustomFilledButton(
                  title: 'Kembali ke Beranda',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/main-admin', (route) => false);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
