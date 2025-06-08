// import 'package:aplikasi_bsu/ui/pages/poin_redeem_success_page.dart';
import 'package:flutter/material.dart';
import '../../shared/theme.dart';
// import '../pages/poin_redeem_success_page.dart';

class ConfirmChangesProduct extends StatefulWidget {
  final String title;
  final int price;
  final Function(int totalItems) onConfirm; // Tambahkan parameter callback

  const ConfirmChangesProduct({
    super.key,
    required this.title,
    required this.price,
    required this.onConfirm, // Inisialisasi callback
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
    setState(() {
      _price = _counter * widget.price;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      _updatePrice();
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
        _updatePrice();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
          horizontal: 10, vertical: 20), // Atur padding inset
      alignment: Alignment.bottomCenter,
      content: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize:
                MainAxisSize.min, // Menyesuaikan tinggi berdasarkan konten
            children: [
              Text(
                widget.title,
                style: regularTextStyle.copyWith(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Rp $_price', // Menggunakan nilai counter yang dikelola oleh state
                style: blueTextStyle.copyWith(fontSize: 14),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _decrementCounter,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.remove, color: whiteColor),
                    ),
                  ),
                  Text(
                    '$_counter', // Menggunakan nilai counter
                    style: regularTextStyle.copyWith(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: _incrementCounter,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(Icons.add, color: whiteColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(blueColor),
                    elevation: MaterialStateProperty.all<double>(0),
                  ),
                  onPressed: () {
                    widget.onConfirm(
                        _counter); // Kembalikan jumlah item ke parent
                    Navigator.pop(context); // Tutup dialog
                  },
                  child: Text(
                    'Tukar Saldo',
                    style: whiteTextStyle.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
