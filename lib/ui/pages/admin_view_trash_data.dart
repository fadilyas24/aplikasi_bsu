import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrashPage extends StatefulWidget {
  @override
  _TrashPageState createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  List<dynamic> trashList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTrashData();
  }

  Future<void> _fetchTrashData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.60.40.104:5000/trash'));
      if (response.statusCode == 200) {
        setState(() {
          trashList = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data sampah';
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

  Future<void> _addTrash() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.60.40.104:5000/trash'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name_trash': _nameController.text,
          'category_trash': _categoryController.text,
          'point_trash': int.parse(_pointController.text),
        }),
      );
      if (response.statusCode == 201) {
        _nameController.clear();
        _categoryController.clear();
        _pointController.clear();
        _fetchTrashData();
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'Gagal menambahkan data sampah';
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
        title: Text('Lihat Data Sampah'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.only(
                            top: 32, left: 16, right: 16, bottom: 32),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 2 / 2,
                        ),
                        itemCount: trashList.length,
                        itemBuilder: (context, index) {
                          final trash = trashList[index];
                          return Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.blue.shade50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize
                                  .min, // Menghindari penggunaan ukuran maksimum
                              children: [
                                Flexible(
                                  child: Icon(
                                    Icons.recycling,
                                    color: Colors.blue,
                                    size: 48,
                                  ),
                                ),
                                SizedBox(height: 36),
                                Flexible(
                                  child: Text(
                                    trash['name_trash'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue.shade800,
                                    ),
                                    textAlign: TextAlign
                                        .center, // Tambahkan center agar teks rapi
                                  ),
                                ),
                                SizedBox(height: 4),
                                Flexible(
                                  child: Text(
                                    'Kategori: ${trash['category_trash']}',
                                    style: TextStyle(color: Colors.blueGrey),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Flexible(
                                  child: Text(
                                    'Poin: ${trash['point_trash']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _showAddTrashDialog(),
                        icon: Icon(Icons.add),
                        label: Text('Tambah Data Sampah'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.black,
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

  void _showAddTrashDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.recycling, color: Colors.blue),
            SizedBox(width: 8),
            Text('Tambah Data Sampah'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Sampah',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.delete_outline, color: Colors.blue),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category, color: Colors.blue),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _pointController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Poin',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.star, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.blue)),
          ),
          ElevatedButton(
            onPressed: _addTrash,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
