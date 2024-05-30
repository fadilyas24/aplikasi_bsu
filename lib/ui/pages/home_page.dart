import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/widget/buttons.dart';
import 'package:aplikasi_bsu/ui/widget/home_balance_card.dart';
import 'package:flutter/material.dart';
import '../widget/home_activity.dart';
import '../widget/home_banner_carousel.dart';
import '../widget/home_service_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: edge,
          vertical: 20,
        ),
        children: [
          buildCompleteProfile(),
          buildBalanceCard(),
          buildBannerCarousel(),
          buildServices(),
          buildActivity(),
        ],
      ),
    );
  }

  bool isProfileCompleted = false;
  Widget buildCompleteProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: !isProfileCompleted,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: lightBlueColor,
              border: Border.all(width: 1, color: blueColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Selamat Datang!',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Ayo, buat profil Anda lebih lengkap agar kami dapat memberikan layanan yang lebih baik untuk Anda',
                  style: regularTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: regular,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomFilledButton(
                  title: 'Lengkapi Sekarang',
                  onPressed: () {
                    setState(
                      () {
                        isProfileCompleted = true;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBalanceCard() {
    return const Row(
      children: [
        BalanceCard(
          title: 'Poin Kamu',
          balance: '15.000',
          imgUrl: 'assets/img_poin_balance.png',
        ),
        Spacer(),
        BalanceCard(
          title: 'Voucher Kamu',
          balance: '10',
          imgUrl: 'assets/img_voucher_balance.png',
        ),
      ],
    );
  }

  Widget buildBannerCarousel() {
    return const Padding(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: BannerCarousel(),
    );
  }

  Widget buildServices() {
    return Container(
      margin: EdgeInsets.only(
        top: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Layanan Kami',
            style: blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: semiBold,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(
              top: 10,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: whiteColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HomeServiceItem(
                  iconUrl: 'assets/i_location.png',
                  title: 'Lokasi\nPenyetoran',
                ),
                HomeServiceItem(
                  iconUrl: 'assets/i_reward.png',
                  title: 'Tukar\nPoin',
                  onTap: () {
                    Navigator.pushNamed(context, '/redeem-poin');
                  },
                ),
                HomeServiceItem(
                  iconUrl: 'assets/i_other.png',
                  title: 'Lainnya\n',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActivity() {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Aktivitas',
                style: blackTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: semiBold,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/activity');
                },
                child: Text(
                  'Lihat Semua',
                  style:
                      regularTextStyle.copyWith(fontSize: 12, color: greyColor),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(
              top: 10,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: whiteColor,
            ),
            child: const Column(
              children: [
                ActvityItem(
                  iconUrl: 'assets/i_activity_deposit.png',
                  title: 'Menabung Sampah',
                  time: 'Hari ini',
                  value: '+ 500',
                ),
                ActvityItem(
                  iconUrl: 'assets/i_activity_exchange.png',
                  title: 'Menukar Poin',
                  time: '1 Mei 2024',
                  value: '- 1500',
                ),
                ActvityItem(
                  iconUrl: 'assets/i_activity_deposit.png',
                  title: 'Menabung Sampah',
                  time: '25 April 2024',
                  value: '+ 300',
                ),
                ActvityItem(
                  iconUrl: 'assets/i_activity_exchange.png',
                  title: 'Menukar Poin',
                  time: '14 April 2024',
                  value: '- 300',
                ),
                ActvityItem(
                  iconUrl: 'assets/i_activity_deposit.png',
                  title: 'Menabung Sampah',
                  time: '10 April 2024',
                  value: '+ 200',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
