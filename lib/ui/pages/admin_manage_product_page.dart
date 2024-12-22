import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminManageProductPage extends StatefulWidget {
  @override
  _AdminManageProductPageState createState() => _AdminManageProductPageState();
}

class _AdminManageProductPageState extends State<AdminManageProductPage> {
  List<dynamic> productList = [];
  List<dynamic> filteredProductList = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProductData();
  }

  Future<void> _fetchProductData() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.8:5000/products'));
      if (response.statusCode == 200) {
        setState(() {
          productList = json.decode(response.body);
          filteredProductList = productList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data produk';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  void _filterProducts(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        filteredProductList = productList;
      } else {
        filteredProductList = productList
            .where((product) => product['product_name']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _addProduct() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.8:5000/products'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'product_name': _nameController.text,
          'points': int.parse(_pointsController.text),
        }),
      );
      if (response.statusCode == 201) {
        _nameController.clear();
        _pointsController.clear();
        _fetchProductData();
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'Gagal menambahkan data produk';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.1.8:5000/products/$productId'),
      );
      if (response.statusCode == 200) {
        _fetchProductData();
      } else {
        setState(() {
          _errorMessage = 'Gagal menghapus data produk';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  Future<void> _editProduct(String productId) async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.8:5000/products/$productId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'product_name': _nameController.text,
          'points': int.parse(_pointsController.text),
        }),
      );
      if (response.statusCode == 200) {
        _nameController.clear();
        _pointsController.clear();
        _fetchProductData();
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'Gagal mengubah data produk';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kelola Produk',
          style: TextStyle(color: whiteColor),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: _filterProducts,
                        decoration: InputDecoration(
                          labelText: 'Cari Nama Produk',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredProductList.length,
                        itemBuilder: (context, index) {
                          final product = filteredProductList[index];
                          return Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              title: Text(
                                product['product_name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              subtitle: Text('Poin: ${product['points']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () =>
                                        _showEditProductDialog(product),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteProduct(
                                        product['id_product'].toString()),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: _showAddProductDialog,
                        icon: Icon(Icons.add),
                        label: Text('Tambah Produk'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.add_circle, color: Colors.blue),
            SizedBox(width: 8),
            Text('Tambah Produk'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_cart, color: Colors.blue),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Poin',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.star, color: Colors.blue),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: _addProduct,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(Map<String, dynamic> product) {
    _nameController.text = product['product_name'];
    _pointsController.text = product['points'].toString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.edit, color: Colors.blue),
            SizedBox(width: 8),
            Text('Edit Produk'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Poin',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: () => _editProduct(product['id_product'].toString()),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
