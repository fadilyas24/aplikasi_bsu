import 'package:aplikasi_bsu/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentMenu = 0;
  Map<String, dynamic>? userProfile;
  bool isLoading = true;
  List<Map<String, dynamic>> activityLogs = [];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    fetchActivityLogs();
  }

  Future<void> _fetchUserProfile() async {
    String? token = await getToken();

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('https://bsuapp.space/api/user-sessions'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          setState(() {
            userProfile = json.decode(response.body);
            isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat profil')),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan')),
        );
      }
    }
  }

  Future<void> fetchActivityLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      String? userId = prefs.getString('user_id');

      if (token == null || userId == null) {
        throw Exception('Token or User ID is missing');
      }

      final redeemResponse = await http.get(
        Uri.parse('https://bsuapp.space/api/redeem-activities'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final savingsResponse = await http.get(
        Uri.parse(
            'https://bsuapp.space/api/savings-activities?user_id=$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (redeemResponse.statusCode == 200 &&
          savingsResponse.statusCode == 200) {
        final List<dynamic> redeemLogs = json.decode(redeemResponse.body);
        final List<dynamic> savingsLogs = json.decode(savingsResponse.body);

        List<Map<String, dynamic>> combined = [
          ...redeemLogs.map((log) => {
                'type': 'redeem',
                'title': log['title'],
                'productName': log['product_name'] ?? '-',
                'pointsUsed': log['redeemed_points'],
                'date': log['time'],
                'status': log['status'] ?? 'approved',
              }),
          ...savingsLogs.map((log) => {
                'type': 'savings',
                'title': log['title'],
                'productName': 'Menabung',
                'pointsUsed': log['points'],
                'date': log['time'],
              }),
        ];

        combined.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

        setState(() {
          activityLogs = combined;
        });
      } else {
        throw Exception('Gagal mengambil riwayat aktivitas');
      }
    } catch (e) {
      print('Error fetching logs: $e');
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: whiteColor,
        title: Text('Anda telah keluar'),
        content: Text('Anda berhasil keluar dari aplikasi.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Text(
              'OK',
              style: TextStyle(color: blueColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshData() async {
    await _fetchUserProfile();
    await fetchActivityLogs();
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: whiteColor,
            title: Text('Konfirmasi Logout'),
            content: Text('Apakah Anda ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Tidak',
                  style: TextStyle(color: redColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  _logout();
                },
                child: Text(
                  'Iya',
                  style: TextStyle(color: blueColor),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget bottomNavigationBar() {
    switch (currentMenu) {
      case 0:
        return HomePage(
          points: userProfile?['points'] ?? 0,
          voucher: userProfile?['voucher'] ?? 0,
          activityLogs: activityLogs,
          onRedeemSuccess: () async {
            await refreshData(); // Pastikan refresh dijalankan
            setState(() {}); // Update tampilan
          },
        );
      case 1:
        return NotificationsPage();
      case 2:
        return const ProfilePage();
      default:
        return HomePage(
          points: userProfile?['points'] ?? 0,
          voucher: userProfile?['voucher'] ?? 0,
          activityLogs: activityLogs,
          onRedeemSuccess: () async {
            await refreshData();
            setState(() {});
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 80,
          child: BottomAppBar(
            padding: EdgeInsets.zero,
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: whiteColor,
              selectedItemColor: blueColor,
              unselectedItemColor: greyColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: blueTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semiBold,
              ),
              unselectedLabelStyle: blueTextStyle.copyWith(
                fontSize: 12,
                fontWeight: semiBold,
              ),
              currentIndex: currentMenu,
              onTap: (value) {
                setState(() {
                  currentMenu = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/i_home.png',
                    width: 30,
                    color: currentMenu == 0 ? blueColor : greyColor,
                  ),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/i_notification.png',
                    width: 30,
                    color: currentMenu == 1 ? blueColor : greyColor,
                  ),
                  label: 'Notifikasi',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/i_profile.png',
                    width: 30,
                    color: currentMenu == 2 ? blueColor : greyColor,
                  ),
                  label: 'Profil Saya',
                ),
              ],
            ),
          ),
        ),
        body: bottomNavigationBar(),
      ),
    );
  }
}
