import 'package:aplikasi_bsu/ui/widget/activity_card.dart';
import 'package:flutter/material.dart';

import '../../shared/theme.dart';

class ActivtyPages extends StatelessWidget {
  const ActivtyPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: blackColor),
        title: Text(
          'Aktivitas',
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: edge,
          vertical: 20,
        ),
        children: const [
          ActivityCard(
            iconUrl: 'assets/i_activity_deposit.png',
            title: 'Menabung Sampah',
            time: 'Hari ini',
            value: '+ 500',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_exchange.png',
            title: 'Menukar Poin',
            time: '1 Mei 2024',
            value: '- 1500',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_deposit.png',
            title: 'Menabung Sampah',
            time: '25 April 2024',
            value: '+ 300',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_exchange.png',
            title: 'Menukar Poin',
            time: '14 April 2024',
            value: '- 300',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_deposit.png',
            title: 'Menabung Sampah',
            time: '10 April 2024',
            value: '+ 200',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_exchange.png',
            title: 'Menukar Poin',
            time: '14 April 2024',
            value: '- 300',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_deposit.png',
            title: 'Menabung Sampah',
            time: '10 April 2024',
            value: '+ 200',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_exchange.png',
            title: 'Menukar Poin',
            time: '14 April 2024',
            value: '- 300',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_deposit.png',
            title: 'Menabung Sampah',
            time: '10 April 2024',
            value: '+ 200',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_exchange.png',
            title: 'Menukar Poin',
            time: '14 April 2024',
            value: '- 300',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_deposit.png',
            title: 'Menabung Sampah',
            time: '10 April 2024',
            value: '+ 200',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_exchange.png',
            title: 'Menukar Poin',
            time: '14 April 2024',
            value: '- 300',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_deposit.png',
            title: 'Menabung Sampah',
            time: '10 April 2024',
            value: '+ 200',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_exchange.png',
            title: 'Menukar Poin',
            time: '14 April 2024',
            value: '- 300',
          ),
          ActivityCard(
            iconUrl: 'assets/i_activity_deposit.png',
            title: 'Menabung Sampah',
            time: '10 April 2024',
            value: '+ 200',
          ),
        ],
      ),
    );
  }
}
