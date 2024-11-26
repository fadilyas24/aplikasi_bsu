import 'package:aplikasi_bsu/helpers/activity_log_helper.dart';
import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Map<String, dynamic>> activityLogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchActivityLogs();
  }

  Future<void> fetchActivityLogs() async {
    final logs = await ActivityLogHelper.getLogs();
    setState(() {
      activityLogs = logs.reversed.toList(); // Tampilkan log terbaru di atas
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Aktivitas'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : activityLogs.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada aktivitas.',
                    style: greyTextStyle.copyWith(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: activityLogs.length,
                  itemBuilder: (context, index) {
                    final log = activityLogs[index];
                    final productName = log['productName'];
                    final pointsUsed = log['pointsUsed'];
                    final date = DateTime.parse(log['date']);

                    return ListTile(
                      leading: Icon(Icons.history, color: Colors.blue),
                      title: Text(
                        productName,
                        style: blackTextStyle.copyWith(fontSize: 16),
                      ),
                      subtitle: Text(
                        '${date.day}-${date.month}-${date.year} | $pointsUsed Poin',
                        style: greyTextStyle.copyWith(fontSize: 14),
                      ),
                    );
                  },
                ),
    );
  }
}
