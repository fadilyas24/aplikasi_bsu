// import 'package:aplikasi_bsu/ui/widget/user_profile_card.dart'; // Hapus ini
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
    _loadToken();
  }

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
  }

  void _onMenuTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<List<Map<String, dynamic>>> fetchRedeemActivities(
      String userId) async {
    if (_userToken == null) throw Exception('Token tidak ditemukan');

    try {
      final response = await http.get(
        Uri.parse('https://bsuapp.space/api/redeem-activities?user_id=$userId'),
        headers: {'Authorization': 'Bearer $_userToken'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((activity) => Map<String, dynamic>.from(activity))
            .where((activity) =>
                activity['status'] == 'approved') // filter approved only
            .toList();
      } else {
        throw Exception('Gagal mengambil data riwayat penukaran');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSavingsActivities(
      String userId) async {
    if (_userToken == null) throw Exception('Token tidak ditemukan');

    try {
      final response = await http.get(
        Uri.parse(
            'https://bsuapp.space/api/savings-activities?user_id=$userId'),
        headers: {'Authorization': 'Bearer $_userToken'},
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
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Nasabah')),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        children: [
          // Ganti UserProfileCard dengan tampilan manual
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userData['full_name'] ?? 'Nama tidak tersedia',
                    style: blackTextStyle.copyWith(
                        fontSize: 18, fontWeight: semiBold)),
                const SizedBox(height: 4),
                Text(widget.userData['email'] ?? 'Email tidak tersedia',
                    style: greyTextStyle.copyWith(fontSize: 14)),
                const SizedBox(height: 10),
                Text('Saldo: Rp ${widget.userData['points'] ?? 0}',
                    style: blueTextStyle.copyWith(
                        fontSize: 16, fontWeight: medium)),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: _selectedIndex == 0
                    ? CustomFilledButton(
                        title: 'Riwayat Tabungan',
                        width: 175,
                        onPressed: () => _onMenuTap(0))
                    : CustomTextButton(
                        title: 'Riwayat Tabungan',
                        width: 175,
                        onPressed: () => _onMenuTap(0)),
              ),
              Flexible(
                child: _selectedIndex == 1
                    ? CustomFilledButton(
                        title: 'Riwayat Penukaran',
                        width: 175,
                        onPressed: () => _onMenuTap(1))
                    : CustomTextButton(
                        title: 'Riwayat Penukaran',
                        width: 175,
                        onPressed: () => _onMenuTap(1)),
              ),
            ],
          ),
          const SizedBox(height: 10),
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
        padding: EdgeInsets.symmetric(horizontal: edge, vertical: 35),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CustomFilledButton(
            elevation: 20,
            title: 'Tambah Catatan',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: whiteColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Pilih Cara Menabung',
                            style: blackTextStyle.copyWith(fontSize: 18)),
                        const SizedBox(height: 20),
                        ListTile(
                          leading: Icon(Icons.edit, color: blueColor),
                          title: const Text('Input Manual'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/admin-add-savings',
                                arguments: {
                                  'userId':
                                      widget.userData['user_id'].toString(),
                                });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.scale, color: blueColor),
                          title: const Text('Timbangan Digital (IoT)'),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                                context, '/admin-add-savings-iot',
                                arguments: {
                                  'userId':
                                      widget.userData['user_id'].toString(),
                                });
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildRiwayatTabungan() {
    if (_userToken == null) return const Center(child: Text('Memuat token...'));

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchSavingsActivities(widget.userData['user_id'].toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const Center(child: Text('Tidak ada riwayat tabungan'));

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: whiteColor),
          child: Column(
            children: snapshot.data!.map((activity) {
              return ActvityItem(
                iconUrl: 'assets/i_activity_deposit.png',
                title: activity['title'] ?? 'Menabung Sampah',
                time: activity['time'] ?? '-',
                value: '${activity['points'] ?? 0}',
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget buildRiwayatPenukaran() {
    if (_userToken == null) return const Center(child: Text('Memuat token...'));

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchRedeemActivities(widget.userData['user_id'].toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError)
          return Center(child: Text('Error: ${snapshot.error}'));
        if (!snapshot.hasData || snapshot.data!.isEmpty)
          return const Center(child: Text('Tidak ada riwayat penukaran'));

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: whiteColor),
          child: Column(
            children: snapshot.data!.map((activity) {
              return ActvityItem(
                iconUrl: 'assets/i_activity_exchange.png',
                title: activity['title'] ?? '-',
                time: activity['time'] ?? '-',
                value: '${activity['redeemed_points'] ?? 0}',
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
