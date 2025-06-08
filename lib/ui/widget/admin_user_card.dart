import 'package:flutter/material.dart';
import 'package:aplikasi_bsu/shared/theme.dart';

class AdminUserCard extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AdminUserCard({
    Key? key,
    required this.name,
    required this.email,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: whiteColor,
        ),
        child: Row(
          children: [
            // Informasi nasabah
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: blackTextStyle.copyWith(
                      fontWeight: medium,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: greyTextStyle.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Tombol hapus
            if (onDelete != null)
              IconButton(
                icon: Icon(Icons.delete, color: redColor),
                onPressed: onDelete,
                tooltip: 'Hapus Nasabah',
              ),
          ],
        ),
      ),
    );
  }
}
