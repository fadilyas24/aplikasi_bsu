import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminAddSavings extends StatefulWidget {
  final String userId; // Tambahkan parameter user_id dari AdminUserData

  const AdminAddSavings({Key? key, required this.userId}) : super(key: key);

  @override
  State<AdminAddSavings> createState() => _AdminAddSavingsState();
}

class _AdminAddSavingsState extends State<AdminAddSavings> {
  List<Map<String, dynamic>> _trashList = [];
  bool _isLoading = true;
  String _errorMessage = '';
  Map<String, double> _inputWeights = {};
  String? _userToken;

  @override
  void initState() {
    super.initState();
    _loadToken().then((_) => _fetchTrashList());
  }

  // Fungsi untuk mengambil token JWT dari SharedPreferences
  Future<void> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/admin-login');
    } else {
      setState(() {
        _userToken = token;
      });
    }

    // Debugging: log token
    print('Token yang diambil: $_userToken');
  }

  // Fungsi untuk mengambil data sampah dari API
  Future<void> _fetchTrashList() async {
    if (_userToken == null) {
      setState(() {
        _errorMessage = 'Token tidak ditemukan. Harap login ulang.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.8:5000/trash'),
        headers: {'Authorization': 'Bearer $_userToken'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _trashList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
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

  // Fungsi untuk menghitung total poin berdasarkan berat input
  double _calculatePoints(int idTrash, double weight) {
    final trash = _trashList.firstWhere((item) => item['id_trash'] == idTrash, orElse: () => {});
    if (trash.isNotEmpty) {
      double pointPerKg = trash['point_trash']?.toDouble() ?? 0.0;
      return weight * pointPerKg;
    }
    return 0.0;
  }

  // Fungsi untuk menghitung total poin keseluruhan
  double _calculateTotalPoints() {
    double total = 0.0;
    _inputWeights.forEach((idTrash, weight) {
      total += _calculatePoints(int.parse(idTrash), weight);
    });
    return total;
  }

  // Fungsi untuk mengirim data ke backend
  Future<void> _submitSavings() async {
  if (_userToken == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Token tidak ditemukan. Harap login ulang.')),
    );
    return;
  }

  final savingsData = _inputWeights.entries.map((entry) {
    final idTrash = entry.key;
    final weight = entry.value;
    final points = _calculatePoints(int.parse(idTrash), weight);
    return {
      "name_trash": _trashList.firstWhere((trash) => trash['id_trash'].toString() == idTrash)['name_trash'],
      "weight": weight,
      "points": points,
    };
  }).toList();

  final requestBody = {
    "user_id": widget.userId,
    "total_points": _calculateTotalPoints(),
    "savings": savingsData,
  };

  try {
    final response = await http.post(
      Uri.parse('http://192.168.1.8:5000/add-savings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_userToken',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      Navigator.pushNamed(
        context,
        '/admin-add-savings-success',
        arguments: {
          'date': DateTime.now().toString(),
          'savings': savingsData,
          'totalPoints': _calculateTotalPoints(),
        },
      );
    } else {
      throw Exception('Gagal menyimpan tabungan');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Tabungan')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView(
                  padding: EdgeInsets.all(16),
                  children: _trashList.map((trash) {
                    final idTrash = trash['id_trash'].toString();
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.recycling),
                        title: Text(trash['name_trash']),
                        subtitle: Text('Poin per kg: ${trash['point_trash']}'),
                        trailing: SizedBox(
                          width: 120,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Berat (kg)',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _inputWeights[idTrash] = double.tryParse(value) ?? 0.0;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${_calculatePoints(int.parse(idTrash), _inputWeights[idTrash] ?? 0.0).toStringAsFixed(1)} pts',
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitSavings,
        label: Text('Simpan Tabungan'),
        icon: Icon(Icons.save),
      ),
    );
  }
}
