import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  const NotificationCard({
    Key? key,
    required this.title,
    required this.description,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: whiteColor,
      ),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: blackTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold,
                ),
              ),
              Spacer(),
              Text(
                time,
                style: greyTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            description,
            style: regularTextStyle.copyWith(
              fontSize: 12,
              fontWeight: regular,
            ),
          ),
        ],
      ),
    );
  }
}
