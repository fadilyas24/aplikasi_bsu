import 'package:aplikasi_bsu/ui/widget/user_profile_card.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme.dart';
import '../widget/buttons.dart';
import '../widget/home_activity.dart';

class AdminUserData extends StatefulWidget {
  const AdminUserData({super.key});

  @override
  _AdminUserDataState createState() => _AdminUserDataState();
}

class _AdminUserDataState extends State<AdminUserData> {
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
        title: Text('Kelola Nasabah'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: edge),
        children: [
          const UserProfileCard(
            imgUrl: 'assets/img_profile.png',
            name: 'Jack Sparrow',
            email: 'jackseparo@gmail.com',
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _selectedIndex == 0
                  ? CustomFilledButton(
                      title: 'Riwayat Tabungan',
                      width: 175,
                      onPressed: () => _onMenuTap(0),
                    )
                  : CustomTextButton(
                      title: 'Riwayat Tabungan',
                      width: 175,
                      onPressed: () => _onMenuTap(0),
                    ),
              _selectedIndex == 1
                  ? CustomFilledButton(
                      title: 'Riwayat Penukaran',
                      width: 175,
                      onPressed: () => _onMenuTap(1),
                    )
                  : CustomTextButton(
                      title: 'Riwayat Penukaran',
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
              buildRiwayatTabungan(),
              buildRiwayatPenukaran(),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: edge, vertical: 35), // Adjust the padding as needed
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CustomFilledButton(
            elevation: 20,
            title: 'Tambah Catatan',
            onPressed: () {
              Navigator.pushNamed(context, '/admin_add_savings');
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

Widget buildRiwayatTabungan() {
  return Container(
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.only(
      top: 10,
    ),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: whiteColor,
    ),
    child: const Column(
      children: [
        ActvityItem(
          iconUrl: 'assets/i_activity_deposit.png',
          title: 'Menabung Sampah',
          time: 'Hari ini',
          value: '+ 500',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_deposit.png',
          title: 'Menabung Sampah',
          time: '25 April 2024',
          value: '+ 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_deposit.png',
          title: 'Menabung Sampah',
          time: '10 April 2024',
          value: '+ 200',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_deposit.png',
          title: 'Menabung Sampah',
          time: '10 April 2024',
          value: '+ 200',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_deposit.png',
          title: 'Menabung Sampah',
          time: '10 April 2024',
          value: '+ 200',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_deposit.png',
          title: 'Menabung Sampah',
          time: '10 April 2024',
          value: '+ 200',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_deposit.png',
          title: 'Menabung Sampah',
          time: '10 April 2024',
          value: '+ 200',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_deposit.png',
          title: 'Menabung Sampah',
          time: '10 April 2024',
          value: '+ 200',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_deposit.png',
          title: 'Menabung Sampah',
          time: '10 April 2024',
          value: '+ 200',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_deposit.png',
          title: 'Menabung Sampah',
          time: '10 April 2024',
          value: '+ 200',
        ),
      ],
    ),
  );
}

Widget buildRiwayatPenukaran() {
  return Container(
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.only(
      top: 10,
    ),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: whiteColor,
    ),
    child: const Column(
      children: [
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
        ActvityItem(
          iconUrl: 'assets/i_activity_exchange.png',
          title: 'Menukar Poin',
          time: '14 April 2024',
          value: '- 300',
        ),
      ],
    ),
  );
}
