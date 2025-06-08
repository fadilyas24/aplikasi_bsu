import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:aplikasi_bsu/shared/theme.dart';

class AdminValidationPage extends StatefulWidget {
  const AdminValidationPage({super.key});

  @override
  State<AdminValidationPage> createState() => _AdminValidationPageState();
}

class _AdminValidationPageState extends State<AdminValidationPage> {
  List<Map<String, dynamic>> pendingRequests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPendingRequests();
  }

  Future<void> fetchPendingRequests() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('https://bsuapp.space/api/admin/redeem-requests'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        pendingRequests = data.map((e) => e as Map<String, dynamic>).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data validasi.')),
      );
    }
  }

  Future<void> validateRequest(int requestId, String action) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    final response = await http.post(
      Uri.parse('https://bsuapp.space/api/admin/redeem-requests/$requestId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'action': action}),
    );

    if (response.statusCode == 200) {
      final resData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resData['message'] ?? 'Validasi berhasil.')),
      );
      await fetchPendingRequests(); // Refresh daftar
    } else {
      final error = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error['message'] ?? 'Gagal memproses validasi.')),
      );
    }
  }

  String formatDate(String isoTime) {
    final dateTime = DateTime.parse(isoTime).toLocal();
    return DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Validasi Penukaran Poin'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingRequests.isEmpty
              ? const Center(child: Text('Tidak ada permintaan pending.'))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: edge, vertical: 16),
                  itemCount: pendingRequests.length,
                  itemBuilder: (context, index) {
                    final request = pendingRequests[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: blueColor, width: 1),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request['product_name'],
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Saldo Ditukar: Rp ${request['redeemed_points']}',
                            style: greyTextStyle,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'User ID: ${request['user_id']}',
                            style: greyTextStyle.copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Waktu: ${formatDate(request['time'])}',
                            style: greyTextStyle.copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    validateRequest(request['id'], 'reject'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: redColor,
                                ),
                                child: Text(
                                  'Tolak',
                                  style: TextStyle(color: whiteColor),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () =>
                                    validateRequest(request['id'], 'approve'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blueColor,
                                ),
                                child: Text(
                                  'Terima',
                                  style: TextStyle(color: whiteColor),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
