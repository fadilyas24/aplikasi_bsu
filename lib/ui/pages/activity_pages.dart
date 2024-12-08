import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../shared/theme.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Map<String, dynamic>> activityLogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActivityLogs();
  }

  Future<void> fetchActivityLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('Token is missing');
      }

      final response = await http.get(
        Uri.parse('http://192.168.1.8:5000/redeem-activities'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> logs = json.decode(response.body);
        setState(() {
          activityLogs = logs
              .map((log) => {
                    'title': log['title'],
                    'productName': log['product_name'],
                    'pointsUsed': log['redeemed_points'],
                    'date': log['time'],
                  })
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch activity logs');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Aktivitas'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : activityLogs.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada aktivitas.',
                    style: greyTextStyle.copyWith(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: activityLogs.length,
                  itemBuilder: (context, index) {
                    final log = activityLogs[index];
                    final title = log['title'];
                    final productName = log['productName'];
                    final pointsUsed = log['pointsUsed'];
                    final date = DateTime.parse(log['date']);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.card_giftcard,
                                color: Colors.purple, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: blackTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  productName,
                                  style: greyTextStyle.copyWith(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${date.day} ${_getMonthName(date.month)} ${date.year}',
                                  style: greyTextStyle.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '-$pointsUsed Poin',
                            style: blueTextStyle.copyWith(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }
}
