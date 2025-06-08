import 'dart:convert';
import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('Token is missing');
      }

      final response = await http.get(
        Uri.parse('https://bsuapp.space/api/notifications'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          notifications =
              List<Map<String, dynamic>>.from(data['notifications']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch notifications');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Notifikasi',
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: blueColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  elevation: 3,
                  color: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      notification['is_read']
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: notification['is_read'] ? Colors.grey : blueColor,
                    ),
                    title: Text(
                      notification['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(notification['message']),
                    trailing: Text(
                      notification['created_at'],
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
