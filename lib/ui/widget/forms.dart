import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class CustomFormField extends StatefulWidget {
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
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TITLE
        Text(
          widget.title,
          style: blackTextStyle.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 8),

        // INPUT FIELD
        TextFormField(
          obscureText: _obscure,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            hintText: widget.formHintText,
            hintStyle: regularTextStyle.copyWith(fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
