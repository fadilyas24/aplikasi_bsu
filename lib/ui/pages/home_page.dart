import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/pages/activity_pages.dart';
import 'package:aplikasi_bsu/ui/pages/redeem_poin_page.dart';
import 'package:aplikasi_bsu/ui/widget/buttons.dart';
import 'package:aplikasi_bsu/ui/widget/home_balance_card.dart';
import 'package:flutter/material.dart';
import '../widget/home_banner_carousel.dart';
import '../widget/home_service_item.dart';

class HomePage extends StatefulWidget {
  final int points;
  final int voucher;
  final List<Map<String, dynamic>> activityLogs;
  final VoidCallback? onRedeemSuccess;

  const HomePage({
    super.key,
    this.points = 0,
    this.voucher = 0,
    this.activityLogs = const [],
    this.onRedeemSuccess,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isProfileCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: edge, vertical: 20),
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

  Widget buildCompleteProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                Text('Selamat Datang!',
                    style: blackTextStyle.copyWith(
                        fontSize: 16, fontWeight: semiBold)),
                SizedBox(height: 10),
                Text(
                  'Ayo, buat profil Anda lebih lengkap agar kami dapat memberikan layanan yang lebih baik untuk Anda',
                  style: regularTextStyle.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomFilledButton(
                  title: 'Lengkapi Sekarang',
                  onPressed: () {
                    setState(() {
                      isProfileCompleted = true;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.wb_sunny_rounded, color: Colors.orange, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Selamat datang kembali! Yuk mulai aktivitas ramah lingkungan hari ini 🌱',
                    style: blackTextStyle.copyWith(
                        fontSize: 14, fontWeight: medium),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBalanceCard() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ActivityPage()));
            },
            child: BalanceCard(
              title: 'Saldo Kamu',
              balance: 'Rp. ${widget.points}',
              imgUrl: 'assets/img_poin_balance.png',
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ActivityPage()));
            },
            child: BalanceCard(
              title: 'Voucher Kamu',
              balance: widget.voucher.toString(),
              imgUrl: 'assets/img_voucher_balance.png',
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBannerCarousel() {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: BannerCarousel(),
    );
  }

  Widget buildServices() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Layanan Kami',
              style:
                  blackTextStyle.copyWith(fontSize: 18, fontWeight: semiBold)),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top: 15),
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
                  title: 'Tukar\nSaldo',
                  onTap: () async {
                    // Navigasi ke halaman penukaran dan tunggu hasil
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RedeemPointPage(
                          onRedeemSuccess:
                              widget.onRedeemSuccess, // panggil callback
                        ),
                      ),
                    );
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
    List<Map<String, dynamic>> sortedActivityLogs =
        List.from(widget.activityLogs)
          ..sort((a, b) =>
              DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));
    List<Map<String, dynamic>> recentActivityLogs =
        sortedActivityLogs.take(5).toList();

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Aktivitas Transaksi',
                  style: blackTextStyle.copyWith(
                      fontSize: 18, fontWeight: semiBold)),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ActivityPage()));
                },
                child: Text('Lihat Semua',
                    style: regularTextStyle.copyWith(
                        fontSize: 12, color: greyColor)),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(top: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: whiteColor,
            ),
            child: Column(
              children: recentActivityLogs.isNotEmpty
                  ? recentActivityLogs.map<Widget>((log) {
                      final date = DateTime.parse(log['date']);
                      final String type = log['type'] ?? 'savings';
                      final String? status = log['status'];

                      Color statusColor;
                      String statusLabel = '';

                      if (type == 'redeem') {
                        switch (status) {
                          case 'pending':
                            statusColor = Colors.orange;
                            statusLabel = 'Menunggu Validasi';
                            break;
                          case 'rejected':
                            statusColor = Colors.red;
                            statusLabel = 'Ditolak';
                            break;
                          default:
                            statusColor = Colors.green;
                            statusLabel = 'Disetujui';
                        }
                      } else {
                        statusLabel = '';
                        statusColor = Colors.transparent;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              type == 'savings'
                                  ? Icons.savings
                                  : Icons.card_giftcard,
                              color: blueColor,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    log['title'],
                                    style: blackTextStyle.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(log['productName'],
                                      style:
                                          greyTextStyle.copyWith(fontSize: 12)),
                                  Text(
                                    '${date.day} ${_getMonthName(date.month)} ${date.year}',
                                    style: greyTextStyle.copyWith(fontSize: 12),
                                  ),
                                  if (type == 'redeem') ...[
                                    SizedBox(height: 2),
                                    Text(
                                      statusLabel,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Text(
                              '${type == 'savings' ? '+' : '-'} Rp ${log['pointsUsed']}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: blueColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()
                  : [
                      Text(
                        'Belum ada aktivitas.',
                        style: greyTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }
}
