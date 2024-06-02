import 'package:aplikasi_bsu/ui/widget/product_confirm_alert.dart';
import 'package:aplikasi_bsu/ui/widget/redeem_point_item.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme.dart';

class RedeemPointPage extends StatelessWidget {
  const RedeemPointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tukar Poin'),
      ),
      body: GridView.count(
        padding: EdgeInsets.only(top: 30, left: edge, right: edge, bottom: 50),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.68,
        shrinkWrap: true,
        children: [
          RedeemPoinItem(
            imageUrl: 'assets/img_cooking_oil.png',
            title: 'Minyak Goreng',
            price: 500,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmChangesProduct(
                    title: 'Minyak Goreng',
                    imageUrl: 'assets/img_cooking_oil.png',
                    price: 500,
                  );
                },
              );
            },
          ),
          RedeemPoinItem(
            imageUrl: 'assets/img_sugar.png',
            title: 'Gula',
            price: 200,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmChangesProduct(
                    title: 'Gula',
                    imageUrl: 'assets/img_sugar.png',
                    price: 200,
                  );
                },
              );
            },
          ),
          RedeemPoinItem(
            imageUrl: 'assets/img_tea.png',
            title: 'Teh',
            price: 100,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmChangesProduct(
                    title: 'Teh',
                    imageUrl: 'assets/img_tea.png',
                    price: 100,
                  );
                },
              );
            },
          ),
          RedeemPoinItem(
            imageUrl: 'assets/img_money.png',
            title: 'Uang Tunai',
            price: 1000,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfirmChangesProduct(
                    title: 'Uang Tunai',
                    imageUrl: 'assets/img_money.png',
                    price: 1000,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
