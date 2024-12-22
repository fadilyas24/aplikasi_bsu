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
  List<Map<String, dynamic>> activityLogs = []; // Tambahkan properti ini

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    fetchActivityLogs(); // Panggil fungsi untuk fetch log aktivitas
  }

  Future<void> _fetchUserProfile() async {
    String? token = await getToken();

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse(
              'http://192.168.1.8:5000/user-sessions'), // Ganti URL dengan API Anda
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            userProfile = json.decode(response.body);
            isLoading = false;
          });
        } else if (response.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Token has expired')),
          );
        } else if (response.statusCode == 402) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid or missing token')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load profile')),
          );
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token is missing')),
      );
    }
  }

  Future<void> fetchActivityLogs() async {
  try {
    String? token = await getToken();
    if (token == null) throw Exception('Token is missing');

    // Fetch Redeem Activities
    final redeemResponse = await http.get(
      Uri.parse('http://192.168.1.8:5000/redeem-activities'),
      headers: {'Authorization': 'Bearer $token'},
    );

    // Fetch Savings Activities
    final savingsResponse = await http.get(
      Uri.parse('http://192.168.1.8:5000/savings-activities?user_id=${userProfile?['user_id']}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (redeemResponse.statusCode == 200 && savingsResponse.statusCode == 200) {
      final List<dynamic> redeemLogs = json.decode(redeemResponse.body);
      final List<dynamic> savingsLogs = json.decode(savingsResponse.body);

      // Combine Redeem and Savings Activities
      setState(() {
        activityLogs = [
          ...redeemLogs.map((log) => {
                'title': log['title'],
                'productName': log['product_name'] ?? '-',
                'pointsUsed': log['redeemed_points'],
                'date': log['time'],
              }),
          ...savingsLogs.map((log) => {
                'title': log['title'],
                'productName': 'Menabung',
                'pointsUsed': log['points'],
                'date': log['time'],
              }),
        ];
      });
    } else {
      throw Exception('Failed to fetch activity logs');
    }
  } catch (e) {
    print('Error fetching logs: $e');
  }
}


  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Widget bottomNavigationBar() {
    switch (currentMenu) {
      case 0:
        return HomePage(
          points: userProfile?['points'] ?? 0,
          voucher: userProfile?['voucher'] ?? 0,
          activityLogs: activityLogs, // Kirim data log aktivitas ke HomePage
        );
      case 1:
        return const NotificationPage();
      case 2:
        return const ProfilePage();
      default:
        return HomePage(
          points: userProfile?['points'] ?? 0,
          voucher: userProfile?['voucher'] ?? 0,
          activityLogs: activityLogs, // Kirim data log aktivitas ke HomePage
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              debugPrint('Current Menu $value');
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
    );
  }
}
