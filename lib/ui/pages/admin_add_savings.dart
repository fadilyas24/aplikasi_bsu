import 'package:aplikasi_bsu/ui/widget/admin_trash_item.dart';
import 'package:aplikasi_bsu/ui/widget/buttons.dart';
import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class AdminAddSavings extends StatefulWidget {
  const AdminAddSavings({super.key});

  @override
  State<AdminAddSavings> createState() => _AdminAddSavingsState();
}

class _AdminAddSavingsState extends State<AdminAddSavings> {
  int _selectedIndex = 0;

  void _onMenuTap(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: edge),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedIndex == 0
                  ? CustomFilledButton(
                      title: 'Tambah Manual',
                      width: 175,
                      onPressed: () => _onMenuTap(0),
                    )
                  : CustomTextButton(
                      title: 'Tambah Otomatis',
                      width: 175,
                      onPressed: () => _onMenuTap(0),
                    ),
              _selectedIndex == 1
                  ? CustomFilledButton(
                      title: 'Tambah Manual',
                      width: 175,
                      onPressed: () => _onMenuTap(1),
                    )
                  : CustomTextButton(
                      title: 'Tambah Otomatis',
                      width: 175,
                      onPressed: () => _onMenuTap(1),
                    ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          IndexedStack(
            index: _selectedIndex,
            children: [
              buildTambahManual(),
              buildTambahOtomatis(),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: edge, vertical: 20), // Adjust the padding as needed
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CustomFilledButton(
            elevation: 20,
            title: 'Tambah Catatan',
            onPressed: () {
              Navigator.pushNamed(context, '/admin-add-savings-success');
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget buildTambahManual() {
  return GridView.count(
    // padding: EdgeInsets.only(top: 30, left: edge, right: edge, bottom: 50),
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
  );
}

Widget buildTambahOtomatis() {
  return GridView.count(
    // padding: EdgeInsets.only(top: 30, left: edge, right: edge, bottom: 50),
    crossAxisCount: 2,
    crossAxisSpacing: 20,
    mainAxisSpacing: 20,
    childAspectRatio: 0.65,
    shrinkWrap: true,
    children: const [
      AdminTrashItemAutomatic(
        imageUrl: 'assets/img_plastik.png',
        title: 'Plastik',
      ),
      AdminTrashItemAutomatic(
        imageUrl: 'assets/img_kertas.png',
        title: 'Kertas',
      ),
      AdminTrashItemAutomatic(
        imageUrl: 'assets/img_minyak_jelantah.png',
        title: 'Minyak Jelantah',
      ),
      AdminTrashItemAutomatic(
        imageUrl: 'assets/img_kaca.png',
        title: 'Kaca',
      ),
    ],
  );
}
