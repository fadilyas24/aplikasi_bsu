import 'package:flutter/material.dart';
import 'package:aplikasi_bsu/shared/theme.dart';

class AdminTrashItem extends StatelessWidget {
  final String imageUrl;
  final String title;

  final VoidCallback? onTap;

  const AdminTrashItem({
    Key? key,
    required this.imageUrl,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: whiteColor,
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 149,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: regularTextStyle.copyWith(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 10),
            QuantityField(),
          ],
        ),
      ),
    );
  }
}

class QuantityField extends StatefulWidget {
  @override
  _QuantityFieldState createState() => _QuantityFieldState();
}

class _QuantityFieldState extends State<QuantityField> {
  double _quantity = 0;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = _quantity.toString();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _controller.text = _quantity.toString();
    });
  }

  void _decrementQuantity() {
    if (_quantity > 0) {
      setState(() {
        _quantity--;
        _controller.text = _quantity.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: _quantity > 0 ? blueColor : lightGreyColor,
            ),
            child: Center(
              child: IconButton(
                color: _quantity > 0 ? whiteColor : whiteColor,
                icon: Icon(Icons.remove),
                iconSize: 20,
                onPressed: _quantity > 0 ? _decrementQuantity : null,
              ),
            ),
          ),
          SizedBox(
            height: 35,
            width: 65,
            child: TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixText: 'Kg',
                suffixStyle: regularTextStyle,
              ),
              onChanged: (value) {
                double? newValue = double.tryParse(value);
                if (newValue != null && newValue >= 0) {
                  setState(() {
                    _quantity = newValue;
                  });
                } else if (value.isEmpty) {
                  setState(() {
                    _quantity = 0;
                  });
                } else {
                  _controller.text = _quantity.toString();
                }
              },
            ),
          ),
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: blueColor),
            child: Center(
              child: IconButton(
                color: whiteColor,
                icon: Icon(Icons.add),
                iconSize: 20,
                onPressed: _incrementQuantity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
