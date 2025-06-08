import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class AddSavingsWithBluetoothPage extends StatefulWidget {
  final String userId;

  const AddSavingsWithBluetoothPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<AddSavingsWithBluetoothPage> createState() =>
      _AddSavingsWithBluetoothPageState();
}

class _AddSavingsWithBluetoothPageState
    extends State<AddSavingsWithBluetoothPage> {
  BluetoothConnection? _connection;
  bool _isConnecting = false;
  bool _isConnected = false;

  double _weight = 0.0;
  String? _selectedTrashName;
  double _selectedTrashPoint = 0.0;
  String? _userToken;
  List<Map<String, dynamic>> _trashList = [];

  @override
  void initState() {
    super.initState();
    _setup();
  }

  Future<void> _setup() async {
    await _requestPermissions();
    await _initBluetooth();
    await _loadToken();
    await _fetchTrashList();
  }

  Future<void> _requestPermissions() async {
    final status = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (status.values.any((permission) => !permission.isGranted)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mohon izinkan akses Bluetooth dan lokasi.")),
      );
    }
  }

  Future<void> _initBluetooth() async {
    final isEnabled = await FlutterBluetoothSerial.instance.isEnabled;
    if (!isEnabled!) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }

    final bondedDevices =
        await FlutterBluetoothSerial.instance.getBondedDevices();

    for (var device in bondedDevices) {
      if (device.name == 'HC-05') {
        _connectToDevice(device);
        break;
      }
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() => _isConnecting = true);

    try {
      final connection = await BluetoothConnection.toAddress(device.address);
      print('✅ Terhubung ke ${device.name}');
      _connection = connection;
      setState(() => _isConnected = true);

      connection.input!.listen((data) {
        final dataStr = utf8.decode(data).trim();
        print('📥 Data mentah dari timbangan: "$dataStr"');

// Gunakan regex untuk ambil hanya angka (opsional + tanda desimal)
        final match = RegExp(r'^-?\d+(\.\d+)?$').firstMatch(dataStr);
        if (match != null) {
          final weight = double.tryParse(match.group(0)!);
          if (weight != null && mounted) {
            setState(() {
              _weight = weight / 1000; // misal jika dalam gram
            });
          }
        } else {
          print('⚠️ Data tidak valid dari timbangan: "$dataStr"');
          if (mounted) {
            setState(() {
              _weight = 0.0;
            });
          }
        }
      }).onDone(() {
        print('⚠️ Koneksi ke ${device.name} terputus.');
        if (mounted) {
          setState(() => _isConnected = false);
        }
      });
    } catch (e) {
      print('❌ Gagal menghubungkan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghubungkan ke HC-05")),
      );
    } finally {
      setState(() => _isConnecting = false);
    }
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _userToken = prefs.getString('token');
  }

  Future<void> _fetchTrashList() async {
    if (_userToken == null) return;

    final response = await http.get(
      Uri.parse('https://bsuapp.space/api/trash'),
      headers: {'Authorization': 'Bearer $_userToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _trashList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    }
  }

  double get _calculatedPoints => _weight * _selectedTrashPoint;

  Future<void> _submitSavings() async {
    if (_userToken == null || _selectedTrashName == null || _weight <= 0)
      return;

    final requestBody = {
      "user_id": widget.userId,
      "total_points": _calculatedPoints,
      "savings": [
        {
          "name_trash": _selectedTrashName,
          "weight": _weight,
          "points": _calculatedPoints,
        }
      ]
    };

    final response = await http.post(
      Uri.parse('https://bsuapp.space/api/add-savings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_userToken',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Tutup koneksi sebelum navigasi
      if (_connection != null && _isConnected) {
        try {
          await _connection?.close();
          print('🔌 Koneksi Bluetooth ditutup sebelum pindah halaman.');
        } catch (e) {
          print('❗ Gagal menutup koneksi Bluetooth: $e');
        }
      }

      if (mounted) {
        Navigator.pushNamed(
          context,
          '/admin-add-savings-success',
          arguments: {
            'date': DateTime.now().toString(),
            'savings': requestBody['savings'],
            'totalPoints': _calculatedPoints,
          },
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim data')),
        );
      }
    }
  }

  @override
  void dispose() {
    _connection?.dispose();
    _connection = null;
    _isConnected = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timbang Sampah Otomatis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _isConnecting
                  ? 'Menghubungkan ke HC-05...'
                  : _isConnected
                      ? 'Terhubung ke HC-05'
                      : 'Timbangan tidak terhubung',
              style: TextStyle(
                color: _isConnected ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              isExpanded: true,
              hint: Text('Pilih jenis sampah'),
              value: _selectedTrashName,
              items: _trashList.map((trash) {
                return DropdownMenuItem<String>(
                  value: trash['name_trash'],
                  child: Text(trash['name_trash']),
                );
              }).toList(),
              onChanged: (value) {
                final selected =
                    _trashList.firstWhere((t) => t['name_trash'] == value);
                setState(() {
                  _selectedTrashName = selected['name_trash'];
                  _selectedTrashPoint =
                      (selected['point_trash'] ?? 0).toDouble();
                });
              },
            ),
            const SizedBox(height: 20),
            Text('Berat dari timbangan:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text('${_weight.toStringAsFixed(2)} kg',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            const SizedBox(height: 16),
            Text('Total poin:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(_calculatedPoints.toStringAsFixed(1),
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (_selectedTrashName != null && _weight > 0)
                    ? _submitSavings
                    : null,
                icon: Icon(Icons.save),
                label: Text('Kirim Tabungan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
