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
  bool isLoadingUser = true;
  bool isLoadingProducts = true;
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    fetchProducts();
  }

  Future<void> fetchUserDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        throw Exception('Token is missing');
      }

      final response = await http.get(
        Uri.parse('http://192.168.1.8:5000/user-sessions'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userPoints = data['points'];
          isLoadingUser = false;
        });
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      setState(() {
        isLoadingUser = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.8:5000/products'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          products = data.map((e) => e as Map<String, dynamic>).toList();
          isLoadingProducts = false;
        });
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      setState(() {
        isLoadingProducts = false;
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
        Uri.parse('http://192.168.1.8:5000/redeem-points'),
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
      body: isLoadingUser || isLoadingProducts
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
                    child: GridView.builder(
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.68,
                      ),
                      itemCount: products.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return RedeemPoinItem(
                          imageUrl:
                              'assets/${product['product_name'].toLowerCase()}.png',
                          title: product['product_name'],
                          price: product['points'],
                          onTap: () {
                            if (userPoints < product['points']) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Poin Anda tidak mencukupi untuk menukar item ini.')),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => ConfirmChangesProduct(
                                  title: product['product_name'],
                                  imageUrl:
                                      'assets/${product['product_name'].toLowerCase()}.png',
                                  price: product['points'],
                                  onConfirm: (int totalItems) {
                                    int totalPrice =
                                        totalItems * (product['points'] as int);
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
                                          totalPrice, product['product_name']);
                                    }
                                  },
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
