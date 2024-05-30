// import 'package:aplikasi_bsu/ui/pages/poin_redeem_success_page.dart';
import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class ConfirmChangesProduct extends StatefulWidget {
  final String title;
  final String imageUrl;
  final int price;
  const ConfirmChangesProduct({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
  });

  @override
  State<ConfirmChangesProduct> createState() => _ConfirmChangesProductState();
}

class _ConfirmChangesProductState extends State<ConfirmChangesProduct> {
  int _counter = 1;
  late int _price;

  @override
  void initState() {
    super.initState();
    _price = widget.price; // Inisialisasi harga di initState
  }

  void _updatePrice() {
    setState(
      () {
        _price = _counter * widget.price;
      },
    );
  }

  void _incrementCounter() {
    setState(
      () {
        _counter++;
        _updatePrice();
      },
    );
  }

  void _decrementCounter() {
    setState(
      () {
        if (_counter > 1) {
          _counter--;
          _updatePrice();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.bottomCenter,
      content: Container(
        padding: EdgeInsets.all(15),
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: whiteColor,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(widget.imageUrl),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: regularTextStyle.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$_price Poin', // Menggunakan nilai counter yang dikelola oleh state
                      style: blueTextStyle.copyWith(fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _decrementCounter();
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: blueColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Image.asset(
                              'assets/i_minus.png',
                              color: whiteColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(
                          '$_counter', // Menggunakan nilai counter yang dikelola oleh state
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap: () {
                            _incrementCounter();
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: blueColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Image.asset(
                              'assets/i_plus.png',
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(blueColor),
                  elevation: MaterialStateProperty.all<double>(0),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/redeem-success',
                  );
                },
                child: Text(
                  'Tukar Poin',
                  style: whiteTextStyle.copyWith(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
