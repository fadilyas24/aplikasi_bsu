import 'package:flutter/material.dart';

import '../../shared/theme.dart';

class CustomFormField extends StatelessWidget {
  final String title;
  final String formHintText;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomFormField({
    Key? key,
    required this.title,
    required this.formHintText,
    this.obscureText = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //EMAIL INPUT
        Text(
          title,
          style: blackTextStyle.copyWith(fontSize: 14),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16),
            hintText: formHintText,
            hintStyle: regularTextStyle.copyWith(fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
