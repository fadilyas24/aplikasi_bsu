import 'package:flutter/material.dart';
import 'package:aplikasi_bsu/shared/theme.dart';

class BalanceCard extends StatelessWidget {
  final String title;
  final String balance;
  final String imgUrl;
  const BalanceCard({
    Key? key,
    required this.title,
    required this.balance,
    required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 75,
      margin: EdgeInsets.only(
        top: 20,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            imgUrl,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: whiteTextStyle.copyWith(fontSize: 12, fontWeight: regular),
          ),
          Spacer(),
          Text(
            balance,
            style: whiteTextStyle.copyWith(
              fontSize: 20,
              fontWeight: bold,
            ),
          ),
        ],
      ),
    );
  }
}
