import 'package:flutter/material.dart';
import 'package:aplikasi_bsu/shared/theme.dart';

class HomeServiceItem extends StatelessWidget {
  final String iconUrl;
  final String title;
  const HomeServiceItem({
    Key? key,
    required this.iconUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: blueColor,
            image: DecorationImage(
              image: AssetImage(iconUrl),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          title,
          style: blackTextStyle.copyWith(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
