import 'package:aplikasi_bsu/ui/widget/admin_trash_item.dart';
import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class AdminAddSavings extends StatelessWidget {
  const AdminAddSavings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: GridView.count(
        padding: EdgeInsets.only(top: 30, left: edge, right: edge, bottom: 50),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.65,
        shrinkWrap: true,
        children: const [
          AdminTrashItem(
            imageUrl: 'assets/img_plastik.png',
            title: 'Plastik',
          ),
          AdminTrashItem(
            imageUrl: 'assets/img_kertas.png',
            title: 'Kertas',
          ),
          AdminTrashItem(
            imageUrl: 'assets/img_minyak_jelantah.png',
            title: 'Minyak Jelantah',
          ),
          AdminTrashItem(
            imageUrl: 'assets/img_kaca.png',
            title: 'Kaca',
          ),
        ],
      ),
    );
  }
}
