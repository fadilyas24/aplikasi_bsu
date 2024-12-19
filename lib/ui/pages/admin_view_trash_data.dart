import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrashPage extends StatefulWidget {
  @override
  _TrashPageState createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  List<dynamic> trashList = [];
  List<dynamic> filteredTrashList = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _uomController = TextEditingController();
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTrashData();
  }

  Future<void> _fetchTrashData() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.60.64.39:5000/trash'));
      if (response.statusCode == 200) {
        setState(() {
          trashList = json.decode(response.body);
          filteredTrashList = trashList;
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

  void _filterTrash(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        filteredTrashList = trashList;
      } else {
        filteredTrashList = trashList
            .where((trash) => trash['name_trash']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _addTrash() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.60.64.39:5000/trash'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name_trash': _nameController.text,
          'category_trash': _categoryController.text,
          'deskripsi': _descriptionController.text,
          'uom': _uomController.text,
          'kode': _kodeController.text,
          'point_trash': int.parse(_pointController.text),
        }),
      );
      if (response.statusCode == 201) {
        _nameController.clear();
        _categoryController.clear();
        _descriptionController.clear();
        _uomController.clear();
        _kodeController.clear();
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

  Future<void> _deleteTrash(String trashId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.60.64.39:5000/trash/$trashId'),
      );
      if (response.statusCode == 200) {
        _fetchTrashData();
      } else {
        setState(() {
          _errorMessage = 'Gagal menghapus data sampah';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  Future<void> _editTrash(String trashId) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.60.64.39:5000/trash/$trashId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name_trash': _nameController.text,
          'category_trash': _categoryController.text,
          'deskripsi': _descriptionController.text,
          'uom': _uomController.text,
          'kode': _kodeController.text,
          'point_trash': int.parse(_pointController.text),
        }),
      );
      if (response.statusCode == 200) {
        _nameController.clear();
        _categoryController.clear();
        _descriptionController.clear();
        _uomController.clear();
        _kodeController.clear();
        _pointController.clear();
        _fetchTrashData();
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'Gagal mengubah data sampah';
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
          'Lihat Data Sampah',
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
                        onChanged: _filterTrash,
                        decoration: InputDecoration(
                          labelText: 'Cari Nama Sampah',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1 / 3,
                        ),
                        itemCount: filteredTrashList.length,
                        itemBuilder: (context, index) {
                          final trash = filteredTrashList[index];
                          return Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Icon(
                                    Icons.recycling,
                                    color: Colors.blue,
                                    size: 48,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    trash['name_trash'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue.shade800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Kategori: ${trash['category_trash']}',
                                    style: TextStyle(color: Colors.blueGrey),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Deskripsi: ${trash['deskripsi']}',
                                    style: TextStyle(color: Colors.blueGrey),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'UOM: ${trash['uom']}',
                                    style: TextStyle(color: Colors.blueGrey),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Kode: ${trash['kode']}',
                                    style: TextStyle(color: Colors.blueGrey),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Poin: ${trash['point_trash']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        _showEditTrashDialog(trash),
                                    icon: Icon(Icons.edit),
                                    label: Text('Edit'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      if (trash['id_trash'] == null) {
                                        setState(() {
                                          _errorMessage =
                                              'ID sampah tidak valid';
                                        });
                                        return;
                                      }
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Konfirmasi'),
                                          content: Text(
                                            'Apakah Anda yakin ingin menghapus data "${trash['name_trash']}"?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Batal'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteTrash(trash['id_trash']
                                                    .toString());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              child: Text('Hapus'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                    label: Text('Hapus'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
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
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category, color: Colors.blue),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _uomController,
                decoration: InputDecoration(
                  labelText: 'UOM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category, color: Colors.blue),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _kodeController,
                decoration: InputDecoration(
                  labelText: 'Kode',
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

  void _showEditTrashDialog(Map<String, dynamic> trash) {
    _nameController.text = trash['name_trash'];
    _categoryController.text = trash['category_trash'];
    _descriptionController.text = trash['deskripsi'];
    _uomController.text = trash['uom'];
    _kodeController.text = trash['kode'];
    _pointController.text = trash['point_trash'].toString();

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
            Text('Edit Data Sampah'),
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
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _uomController,
                decoration: InputDecoration(
                  labelText: 'UOM',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _kodeController,
                decoration: InputDecoration(
                  labelText: 'Kode',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _pointController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Poin',
                  border: OutlineInputBorder(),
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
            onPressed: () => _editTrash(trash['id_trash'].toString()),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
