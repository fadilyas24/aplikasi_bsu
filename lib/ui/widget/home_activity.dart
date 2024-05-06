import 'package:flutter/material.dart';

import '../../shared/theme.dart';

class ActvityItem extends StatelessWidget {
  final String iconUrl;
  final String title;
  final String time;
  final String value;
  final String? color;

  const ActvityItem({
    Key? key,
    required this.iconUrl,
    required this.title,
    required this.time,
    required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
      ),
      child: Row(
        children: [
          Image.asset(
            iconUrl,
            width: 48,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: blackTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  time,
                  style: greyTextStyle.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$value Poin',
            style: blackTextStyle.copyWith(
              fontWeight: semiBold,
              fontSize: 14,
              color: blueColor,
            ),
          ),
        ],
      ),
    );
  }
}
