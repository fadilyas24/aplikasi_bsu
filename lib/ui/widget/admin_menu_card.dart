import 'package:flutter/material.dart';
import 'package:aplikasi_bsu/shared/theme.dart';

class AdminMenuCard extends StatelessWidget {
  final String title;
  final String iconUrl;
  final VoidCallback onTap;
  const AdminMenuCard({
    super.key,
    required this.title,
    required this.iconUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: whiteColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(15),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: lightBlueColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: Image.asset(
                  iconUrl,
                  color: blueColor,
                )),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              title,
              style: regularTextStyle.copyWith(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
