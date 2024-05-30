import 'package:flutter/material.dart';
import '../../../shared/theme.dart';

class RedeemPoinItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int price;
  final VoidCallback? onTap;
  const RedeemPoinItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: whiteColor,
        ),
        padding: EdgeInsets.all(12),
        // height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 149,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: regularTextStyle.copyWith(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '$price Poin',
              style: blackTextStyle.copyWith(
                  fontSize: 20, fontWeight: semiBold, color: blueColor),
            ),
          ],
        ),
      ),
    );
  }
}
