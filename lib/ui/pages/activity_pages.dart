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
      String? userId =
          prefs.getString('user_id'); // Ambil user_id dari SharedPreferences

      if (token == null || userId == null) {
        throw Exception('Token or User ID is missing');
      }

      // Fetch redeem activities
      final redeemResponse = await http.get(
        Uri.parse('http://10.60.66.62:5000/redeem-activities'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Fetch savings activities
      final savingsResponse = await http.get(
        Uri.parse('http://10.60.66.62:5000/savings-activities?user_id=$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (redeemResponse.statusCode == 200 &&
          savingsResponse.statusCode == 200) {
        final List<dynamic> redeemLogs = json.decode(redeemResponse.body);
        final List<dynamic> savingsLogs = json.decode(savingsResponse.body);

        setState(() {
          activityLogs = [
            ...redeemLogs.map((log) => {
                  'type': 'redeem',
                  'title': log['title'],
                  'productName': log['product_name'],
                  'points': log['redeemed_points'],
                  'date': log['time'],
                }),
            ...savingsLogs.map((log) => {
                  'type': 'savings',
                  'title': log['title'],
                  'points': log['points'],
                  'date': log['time'],
                }),
          ];
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
                    final type = log['type'];
                    final title = log['title'];
                    final points = log['points'];
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
                              color: type == 'redeem'
                                  ? Colors.blue[50]
                                  : Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              type == 'redeem'
                                  ? Icons.card_giftcard
                                  : Icons.savings,
                              color:
                                  type == 'redeem' ? Colors.blue : Colors.blue,
                              size: 28,
                            ),
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
                                if (type == 'redeem')
                                  Text(
                                    log['productName'],
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
                            '${type == 'redeem' ? '-' : '+'}$points Poin',
                            style: type == 'redeem'
                                ? blueTextStyle.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.bold)
                                : blueTextStyle.copyWith(
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
