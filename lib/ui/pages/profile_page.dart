// import 'package:aplikasi_bsu/ui/pages/change_password.dart';
// import 'package:aplikasi_bsu/ui/widget/profile_item.dart';
// import 'package:aplikasi_bsu/ui/widget/user_profile_card.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:aplikasi_bsu/ui/pages/edit_profile.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../shared/theme.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   Map<String, dynamic>? userProfile;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchUserProfile();
//   }

//   Future<void> _fetchUserProfile() async {
//     String? token = await getToken();

//     if (token != null) {
//       try {
//         final response = await http.get(
//           Uri.parse('http://10.60.64.39:5000/user-sessions'),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         );

//         if (response.statusCode == 200) {
//           setState(() {
//             userProfile = json.decode(response.body);
//             isLoading = false;
//           });
//         } else if (response.statusCode == 401) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Token has expired')),
//           );
//         } else if (response.statusCode == 402) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Invalid or missing token')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Failed to load profile')),
//           );
//         }
//       } catch (e) {
//         setState(() {
//           isLoading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('An error occurred')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Token is missing')),
//       );
//     }
//   }

//   Future<String?> getToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('jwt_token');
//   }

//   Future<void> _refreshProfile() async {
//     // Refresh user profile data
//     await _fetchUserProfile();
//   }

//   Future<void> logoutUser(BuildContext context) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('jwt_token');

//     // Arahkan pengguna kembali ke halaman login
//     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: lightColor,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Profil Saya'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView(
//               padding: EdgeInsets.symmetric(
//                 horizontal: edge,
//               ),
//               children: [
//                 Container(
//                   width: double.infinity,
//                   margin: const EdgeInsets.only(
//                     top: 20,
//                   ),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: whiteColor,
//                   ),
//                   child: Column(
//                     children: [
//                       UserProfileCard(
//                         imgUrl: userProfile?['profile_picture_url'] ??
//                             'assets/img_profile.png', // Ambil URL gambar dari API
//                         name:
//                             userProfile?['full_name'] ?? 'Nama tidak ditemukan',
//                         email: userProfile?['email'] ?? 'Email tidak ditemukan',
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 25),
//                 ProfileItem(
//                   title: 'Edit Profil',
//                   iconUrl: 'assets/i_profile_bold.png',
//                   iconColor: blueColor,
//                   onTap: () async {
//                     final bool? result = await Navigator.push<bool?>(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => EditProfilePage(),
//                       ),
//                     );
//                     if (result == true) {
//                       _refreshProfile(); // Panggil ulang untuk refresh data setelah edit
//                     }
//                   },
//                 ),
//                 ProfileItem(
//                   title: 'Ubah Bahasa',
//                   iconUrl: 'assets/i_language.png',
//                   iconColor: blueColor,
//                 ),
//                 ProfileItem(
//                   title: 'Ubah Password',
//                   iconUrl: 'assets/i_password.png',
//                   iconColor: blueColor,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChangePasswordScreen(),
//                       ),
//                     );
//                   },
//                 ),
//                 ProfileItem(
//                   title: 'Pusat Bantuan',
//                   iconUrl: 'assets/i_help_center.png',
//                   iconColor: blueColor,
//                 ),
//                 ProfileItem(
//                   title: 'Logout',
//                   iconUrl: 'assets/i_logout.png',
//                   iconColor: whiteColor,
//                   color: redColor,
//                   textColor: whiteColor,
//                   onTap: () async {
//                     await logoutUser(context);
//                   },
//                 ),
//                 const SizedBox(
//                   height: 50,
//                 ),
//               ],
//             ),
//     );
//   }
// }

import 'package:aplikasi_bsu/ui/pages/change_password.dart';
import 'package:aplikasi_bsu/ui/widget/profile_item.dart';
import 'package:aplikasi_bsu/ui/widget/user_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_bsu/ui/pages/edit_profile.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    String? token = await getToken();

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://10.60.64.39:5000/user-sessions'),
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

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> _refreshProfile() async {
    // Refresh user profile data
    await _fetchUserProfile();
  }

  Future<void> logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');

    // Tampilkan animasi pop-up
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 60,
              ),
              const SizedBox(height: 10),
              Text(
                'Logout Berhasil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text('Anda telah keluar dari akun Anda.'),
            ],
          ),
        );
      },
    );

    // Tunggu beberapa detik sebelum mengarahkan ke halaman login
    await Future.delayed(Duration(seconds: 2));

    Navigator.of(context).pop(); // Tutup dialog

    // Arahkan pengguna kembali ke halaman login
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil Saya'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.symmetric(
                horizontal: edge,
              ),
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: whiteColor,
                  ),
                  child: Column(
                    children: [
                      UserProfileCard(
                        imgUrl: userProfile?['profile_picture_url'] ??
                            'assets/img_profile.png', // Ambil URL gambar dari API
                        name:
                            userProfile?['full_name'] ?? 'Nama tidak ditemukan',
                        email: userProfile?['email'] ?? 'Email tidak ditemukan',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                ProfileItem(
                  title: 'Edit Profil',
                  iconUrl: 'assets/i_profile_bold.png',
                  iconColor: blueColor,
                  onTap: () async {
                    final bool? result = await Navigator.push<bool?>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    );
                    if (result == true) {
                      _refreshProfile(); // Panggil ulang untuk refresh data setelah edit
                    }
                  },
                ),
                ProfileItem(
                  title: 'Ubah Bahasa',
                  iconUrl: 'assets/i_language.png',
                  iconColor: blueColor,
                ),
                ProfileItem(
                  title: 'Ubah Password',
                  iconUrl: 'assets/i_password.png',
                  iconColor: blueColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                ProfileItem(
                  title: 'Pusat Bantuan',
                  iconUrl: 'assets/i_help_center.png',
                  iconColor: blueColor,
                ),
                ProfileItem(
                  title: 'Logout',
                  iconUrl: 'assets/i_logout.png',
                  iconColor: whiteColor,
                  color: redColor,
                  textColor: whiteColor,
                  onTap: () async {
                    await logoutUser(context);
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
    );
  }
}
