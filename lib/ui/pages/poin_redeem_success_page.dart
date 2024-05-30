import 'package:flutter/material.dart';

import '../../shared/theme.dart';
import '../widget/buttons.dart';
import 'home_page.dart';

class PoinRedeemSuccessPage extends StatelessWidget {
  const PoinRedeemSuccessPage({super.key});

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
                  'Penukaran Poin Berhasil',
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
                Text(
                  'Anda telah berhasil menukarkan poin, tetap menabung sampah dan dapatkan hadiah lainnya',
                  style: greyTextStyle.copyWith(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
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
                            'Nama Barang',
                            style: blackTextStyle.copyWith(fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            'Minyak Goreng',
                            style: greyTextStyle.copyWith(
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
                            'Tanggal Penukaran',
                            style: blackTextStyle.copyWith(fontSize: 14),
                          ),
                          Spacer(),
                          Text(
                            '31 Mei 2024',
                            style: greyTextStyle.copyWith(
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
                            'Total Poin',
                            style: blackTextStyle.copyWith(
                                fontSize: 14, fontWeight: medium),
                          ),
                          Spacer(),
                          Text(
                            '10 Poin',
                            style: greyTextStyle.copyWith(
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
                            'Status',
                            style: blackTextStyle.copyWith(fontSize: 14),
                          ),
                          Spacer(),
                          Container(
                            width: 130,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: redColor),
                            child: Center(
                              child: Text(
                                'Belum diambil',
                                style: whiteTextStyle.copyWith(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                CustomFilledButton(
                  title: 'Kembali ke Beranda',
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/main-home', (route) => false);
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
