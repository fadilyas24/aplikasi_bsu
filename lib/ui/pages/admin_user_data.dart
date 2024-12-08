import 'package:aplikasi_bsu/ui/widget/user_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/theme.dart';
import '../widget/buttons.dart';
import '../widget/home_activity.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminUserData extends StatefulWidget {
  final Map<String, dynamic> userData;
  const AdminUserData({super.key, required this.userData});

  @override
  _AdminUserDataState createState() => _AdminUserDataState();
}

class _AdminUserDataState extends State<AdminUserData> {
  int _selectedIndex = 0;
  String? _userToken;

  @override
  void initState() {
    super.initState();
    print("InitState dipanggil");
    _loadToken().then((_) {
      print("Token setelah load: $_userToken");
    });
  }

  // Fungsi untuk mengambil token dari SharedPreferences
  Future<void> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/admin-login');
    } else {
      setState(() {
        _userToken = token;
      });
    }

    // Debugging: Log token
    print('Token yang diambil: $_userToken');
  }

  void _onMenuTap(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchRedeemActivities(
      String userId) async {
    if (_userToken == null) {
      throw Exception('Token tidak ditemukan. Harap login ulang.');
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.8:5000/redeem-activities?user_id=$userId'),
        headers: {
          'Authorization': 'Bearer $_userToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((activity) => Map<String, dynamic>.from(activity))
            .toList();
      } else {
        throw Exception('Gagal mengambil data riwayat penukaran');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSavingsActivities(
      String userId) async {
    if (_userToken == null) {
      throw Exception('Token tidak ditemukan. Harap login ulang.');
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.8:5000/savings-activities?user_id=$userId'),
        headers: {
          'Authorization': 'Bearer $_userToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((activity) => Map<String, dynamic>.from(activity))
            .toList();
      } else {
        throw Exception('Gagal mengambil data riwayat tabungan');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Nasabah'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: edge),
        children: [
          UserProfileCard(
            imgUrl: 'assets/img_profile.png',
            name: widget.userData['full_name'] ?? 'Nama tidak tersedia',
            email: widget.userData['email'] ?? 'Email tidak tersedia',
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 10),
          IndexedStack(
            index: _selectedIndex,
            children: [
              buildRiwayatTabungan(),
              buildRiwayatPenukaran(), // Tidak perlu kirim token secara eksplisit
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: edge, vertical: 35),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CustomFilledButton(
            elevation: 20,
            title: 'Tambah Catatan',
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/admin-add-savings',
                arguments: {
                  'userId': widget.userData['user_id'].toString()
                }, // Gunakan widget.userData
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildRiwayatTabungan() {
    if (_userToken == null) {
      return Center(
        child: Text('Memuat token...'),
      );
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchSavingsActivities(widget.userData['user_id'].toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada riwayat tabungan'));
        }

        final activities = snapshot.data!;
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(top: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: whiteColor,
          ),
          child: Column(
            children: activities.map((activity) {
              return ActvityItem(
                iconUrl: 'assets/i_activity_deposit.png',
                title: activity['title'] ?? 'Menabung Sampah',
                time: activity['time'] ?? 'Waktu tidak tersedia',
                value: '+ ${activity['points'] ?? 0}',
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget buildRiwayatPenukaran() {
    if (_userToken == null) {
      return Center(
        child: Text('Memuat token...'),
      );
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchRedeemActivities(widget.userData['user_id'].toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada riwayat penukaran'));
        }

        final activities = snapshot.data!;
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(top: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: whiteColor,
          ),
          child: Column(
            children: activities.map((activity) {
              return ActvityItem(
                iconUrl: 'assets/i_activity_exchange.png',
                title: activity['title'] ?? 'judul tidak tersedia',
                time: activity['time'] ?? 'waktu tidak tersedia',
                value: '- ${activity['redeemed_points'] ?? 0} ',
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
