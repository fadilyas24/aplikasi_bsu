import 'package:flutter/material.dart';



class AdminAddSavingsSuccessPage extends StatelessWidget {
  const AdminAddSavingsSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String date = args['date'];
    final List<Map<String, dynamic>> savings = List<Map<String, dynamic>>.from(args['savings']);
    final double totalPoints = args['totalPoints'];

    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'Tambah Tabungan Berhasil',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/i_green_check.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Rincian Tabungan',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            date,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      ...savings.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Text(
                                item['name_trash'],
                                style: TextStyle(fontSize: 14),
                              ),
                              Spacer(),
                              Text(
                                '${item['points'].toStringAsFixed(1)} Poin',
                                style: TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            '${totalPoints.toStringAsFixed(1)} Poin',
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 130),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/main-admin', (route) => false);
                  },
                  child: Text('Kembali ke Beranda'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
