import 'dart:convert';
import 'package:aplikasi_bsu/helpers/activity_log_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/redeem_point_item.dart';
import 'poin_redeem_success_page.dart';
import 'package:aplikasi_bsu/ui/widget/product_confirm_alert.dart';

class RedeemPointPage extends StatefulWidget {
  const RedeemPointPage({super.key});

  @override
  State<RedeemPointPage> createState() => _RedeemPointPageState();
}

class _RedeemPointPageState extends State<RedeemPointPage> {
  int userPoints = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('Token is missing');
      }

      final response = await http.get(
        Uri.parse('http://10.60.64.39:5000/user-sessions'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userPoints = data['points'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch user details');
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

  Future<void> redeemPoints(int price, String productName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('Token is missing');
      }

      final response = await http.post(
        Uri.parse('http://10.60.64.39:5000/redeem-points'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'price': price,
          'product_name': productName,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        int updatedPoints = data['new_points'];

        setState(() {
          userPoints = updatedPoints;
        });

        // Simpan log aktivitas
        await ActivityLogHelper.saveLog(productName, price);

        // Navigasi ke halaman sukses dengan detail produk
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PoinRedeemSuccessPage(
              productName: productName,
              pointsUsed: price,
              currentDate: DateTime.now(),
            ),
          ),
        );
      } else {
        throw Exception(json.decode(response.body)['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tukar Poin'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Poin Anda:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$userPoints',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, right: 10, left: 10),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.68,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          RedeemPoinItem(
                            imageUrl: 'assets/img_cooking_oil.png',
                            title: 'Minyak Goreng',
                            price: 500,
                            onTap: () {
                              if (userPoints < 500) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Poin Anda tidak mencukupi untuk menukar item ini.')),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => ConfirmChangesProduct(
                                    title: 'Minyak Goreng',
                                    imageUrl: 'assets/img_cooking_oil.png',
                                    price: 500,
                                    onConfirm: (int totalItems) {
                                      int totalPrice = totalItems * 500;
                                      if (userPoints < totalPrice) {
                                        Navigator.pop(
                                            context); // Tutup dialog jika poin tidak mencukupi
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Poin Anda tidak mencukupi untuk jumlah item ini.')),
                                        );
                                      } else {
                                        redeemPoints(
                                            totalPrice, 'Minyak Goreng');
                                      }
                                    }, // Hitung total poin
                                  ),
                                );
                              }
                            },
                          ),
                          RedeemPoinItem(
                            imageUrl: 'assets/img_sugar.png',
                            title: 'Gula',
                            price: 200,
                            onTap: () {
                              if (userPoints < 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Poin Anda tidak mencukupi untuk menukar item ini.')),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => ConfirmChangesProduct(
                                    title: 'Gula',
                                    imageUrl: 'assets/img_sugar.png',
                                    price: 200,
                                    onConfirm: (int totalItems) {
                                      int totalPrice = totalItems * 200;
                                      // Hitung total poin
                                      if (userPoints < totalPrice) {
                                        Navigator.pop(
                                            context); // Tutup dialog jika poin tidak mencukupi
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Poin Anda tidak mencukupi untuk jumlah item ini.')),
                                        );
                                      } else {
                                        redeemPoints(totalPrice, 'Gula');
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                          // Tambahkan item lainnya
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
