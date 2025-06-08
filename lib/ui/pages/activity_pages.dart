import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/theme.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> activityLogs = [];
  bool isLoading = true;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  String selectedType = 'all';
  String userName = '';
  int totalBalance = 0;

  late AnimationController _gradientController;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();
    fetchUserSession();
    fetchActivityLogs();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _color1 = ColorTween(begin: Colors.blue, end: Colors.lightBlueAccent)
        .animate(_gradientController);
    _color2 = ColorTween(begin: Colors.indigo, end: Colors.cyan)
        .animate(_gradientController);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  Future<void> fetchUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    if (token == null) return;

    final response = await http.get(
      Uri.parse('https://bsuapp.space/api/user-sessions'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        totalBalance = data['points'] ?? 0;
        userName = data['full_name'] ?? '';
      });
    }
  }

  Future<void> fetchActivityLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');
      String? userId = prefs.getString('user_id');

      if (token == null || userId == null) throw Exception('Missing token/userId');

      final redeemResponse = await http.get(
        Uri.parse('https://bsuapp.space/api/redeem-activities'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final savingsResponse = await http.get(
        Uri.parse('https://bsuapp.space/api/savings-activities?user_id=$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (redeemResponse.statusCode == 200 && savingsResponse.statusCode == 200) {
        final redeemLogs = json.decode(redeemResponse.body) as List;
        final savingsLogs = json.decode(savingsResponse.body) as List;

        List<Map<String, dynamic>> combined = [
          ...redeemLogs.map((log) => {
                'type': 'redeem',
                'title': log['title'],
                'productName': log['product_name'],
                'points': log['redeemed_points'],
                'date': log['time'],
                'status': log['status'] ?? 'approved',
              }),
          ...savingsLogs.map((log) => {
                'type': 'savings',
                'title': log['title'],
                'points': log['points'],
                'date': log['time'],
              }),
        ];

        combined.sort((a, b) =>
            DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

        setState(() {
          activityLogs = combined;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch logs');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  List<Map<String, dynamic>> getFilteredLogs() {
    return activityLogs.where((log) {
      final date = DateTime.parse(log['date']);
      final bool matchesMonth = date.month == selectedMonth;
      final bool matchesYear = date.year == selectedYear;
      final bool matchesType =
          selectedType == 'all' || log['type'] == selectedType;
      return matchesMonth && matchesYear && matchesType;
    }).toList();
  }

  List<int> getAvailableYears() {
    final years = activityLogs
        .map((log) => DateTime.parse(log['date']).year)
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    return years;
  }

  void _showAdvancedFilterPopup() {
    int tempYear = selectedYear;
    String tempType = selectedType;

    final availableYears = getAvailableYears();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Filter Lanjutan',
                        style: blackTextStyle.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Tahun', style: blackTextStyle),
                    ),
                    if (availableYears.isEmpty)
                      const Text('Belum ada data tahun tersedia.')
                    else
                      ...availableYears.map((year) {
                        return RadioListTile<int>(
                          value: year,
                          groupValue: tempYear,
                          onChanged: (val) {
                            setModalState(() => tempYear = val!);
                          },
                          activeColor: blueColor,
                          title: Text('$year'),
                        );
                      }).toList(),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Jenis Aktivitas', style: blackTextStyle),
                    ),
                    RadioListTile<String>(
                      value: 'all',
                      groupValue: tempType,
                      onChanged: (val) {
                        setModalState(() => tempType = val!);
                      },
                      activeColor: blueColor,
                      title: const Text('Semua Aktivitas'),
                    ),
                    RadioListTile<String>(
                      value: 'savings',
                      groupValue: tempType,
                      onChanged: (val) {
                        setModalState(() => tempType = val!);
                      },
                      activeColor: blueColor,
                      title: const Text('Menabung Sampah'),
                    ),
                    RadioListTile<String>(
                      value: 'redeem',
                      groupValue: tempType,
                      onChanged: (val) {
                        setModalState(() => tempType = val!);
                      },
                      activeColor: blueColor,
                      title: const Text('Menukar Poin'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedYear = tempYear;
                          selectedType = tempType;
                        });
                        Navigator.pop(context);
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: blueColor),
                      child: const Text('Terapkan',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getStatusLabel(String? status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Validasi';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return '';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final filteredLogs = getFilteredLogs();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _color1.value ?? Colors.blue,
                    _color2.value ?? Colors.blue,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  'Transaksi',
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _color1.value ?? blueColor,
                      _color2.value ?? blueColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: const Icon(Icons.eco, color: Colors.white, size: 30),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Halo, $userName!',
                      style: whiteTextStyle.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Rp ${NumberFormat("#,###", "id_ID").format(totalBalance)}',
                      style: whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedYear < DateTime.now().year
                        ? 12
                        : DateTime.now().month,
                    itemBuilder: (context, index) {
                      final month = index + 1;
                      return GestureDetector(
                        onTap: () => setState(() => selectedMonth = month),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: selectedMonth == month
                                ? blueColor
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              _getMonthName(month),
                              style: TextStyle(
                                color: selectedMonth == month
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                IconButton(
                  onPressed: _showAdvancedFilterPopup,
                  icon: Icon(Icons.tune, color: blueColor),
                  tooltip: 'Filter lanjutan',
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredLogs.isEmpty
                    ? Center(
                        child: Text('Belum ada aktivitas.', style: greyTextStyle))
                    : ListView.builder(
                        itemCount: filteredLogs.length,
                        itemBuilder: (context, index) {
                          final log = filteredLogs[index];
                          final type = log['type'];
                          final title = log['title'];
                          final date = DateTime.parse(log['date']);

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue[50],
                              child: Icon(
                                type == 'redeem'
                                    ? Icons.card_giftcard
                                    : Icons.savings,
                                color: blueColor,
                              ),
                            ),
                            title: Text(title, style: blackTextStyle),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (type == 'redeem') ...[
                                  Text(log['productName'], style: greyTextStyle),
                                  Text(
                                    _getStatusLabel(log['status']),
                                    style: TextStyle(
                                      color: _getStatusColor(log['status']),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                                Text(
                                  '${date.day} ${_getMonthName(date.month)} ${date.year}',
                                  style: greyTextStyle,
                                ),
                              ],
                            ),
                            trailing: Text(
                              '${type == 'redeem' ? '-' : '+'} Rp ${log['points']}',
                              style: TextStyle(color: blueColor, fontSize: 14),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
