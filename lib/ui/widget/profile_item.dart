import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class ProfileItem extends StatelessWidget {
  final String title;
  final String iconUrl;
  final Color? color;
  final Color textColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  const ProfileItem({
    Key? key,
    required this.title,
    required this.iconUrl,
    this.color = Colors.white,
    this.textColor = Colors.black,
    required this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          top: 10,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ImageIcon(
                AssetImage(
                  iconUrl,
                ),
                color: iconColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
