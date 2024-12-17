import 'dart:convert';
import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String email;
  final VoidCallback? onTap;

  const UserProfileCard({
    Key? key,
    required this.imgUrl,
    required this.name,
    required this.email,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Tangani aksi saat widget ditekan
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: imgUrl.startsWith('data:image')
                ? MemoryImage(base64Decode(imgUrl.split(',')[1]))
                : AssetImage(imgUrl) as ImageProvider,
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            email,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
