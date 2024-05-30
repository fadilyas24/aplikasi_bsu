import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final Color? borderColor;
  final double? borderWidth;
  final Color? unseenNotification;
  const NotificationCard(
      {Key? key,
      required this.title,
      required this.description,
      required this.time,
      this.borderColor,
      this.borderWidth,
      this.unseenNotification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: unseenNotification ?? whiteColor,
        border: borderColor != null && borderWidth != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth!,
              )
            : null,
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
