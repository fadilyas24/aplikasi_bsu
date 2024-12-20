import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/widget/notification.dart';
import 'package:flutter/material.dart';

class AdminNotificationPage extends StatelessWidget {
  const AdminNotificationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Notifikasi',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: edge,
        ),
        children: [
          Column(
            children: [
              NotificationCard(
                title: 'GRATIS Cashback',
                description:
                    'Ayo kumpulkan sampahmu dan raih voucher cashback hingga 25% berlaku s/d hari ini',
                time: 'Hari ini',
                borderColor: blueColor,
                unseenNotification: lightBlueColor,
                borderWidth: 1,
              ),
              NotificationCard(
                title: 'GRATIS Cashback',
                description:
                    'Ayo kumpulkan sampahmu dan raih voucher cashback hingga 25% berlaku s/d hari ini',
                time: '05 Mei 2024',
                borderColor: blueColor,
                unseenNotification: lightBlueColor,
                borderWidth: 1,
              ),
              NotificationCard(
                title: 'GRATIS Cashback',
                description:
                    'Ayo kumpulkan sampahmu dan raih voucher cashback hingga 25% berlaku s/d hari ini',
                time: '30 April 2024',
                borderColor: blueColor,
                unseenNotification: lightBlueColor,
                borderWidth: 1,
              ),
              NotificationCard(
                title: 'GRATIS Cashback',
                description:
                    'Ayo kumpulkan sampahmu dan raih voucher cashback hingga 25% berlaku s/d hari ini',
                time: '28 April 2024',
              ),
              NotificationCard(
                title: 'GRATIS Cashback',
                description:
                    'Ayo kumpulkan sampahmu dan raih voucher cashback hingga 25% berlaku s/d hari ini',
                time: '26 April 2024',
              ),
              NotificationCard(
                title: 'GRATIS Cashback',
                description:
                    'Ayo kumpulkan sampahmu dan raih voucher cashback hingga 25% berlaku s/d hari ini',
                time: '24 April 2024',
              ),
              NotificationCard(
                title: 'Selamat Datang!',
                description:
                    'Mulai menabung sampah dan tukar poinmu dengan hadiah menarik',
                time: '21 April 2024',
              ),
            ],
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
