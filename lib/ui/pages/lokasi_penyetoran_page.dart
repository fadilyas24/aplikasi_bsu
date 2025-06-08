
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LokasiPenyetoranPage extends StatefulWidget {
//   @override
//   _LokasiPenyetoranPageState createState() => _LokasiPenyetoranPageState();
// }

// class _LokasiPenyetoranPageState extends State<LokasiPenyetoranPage> {
//   late GoogleMapController _mapController;
//   final List<Marker> _markers = [];
//   final List<Map<String, String>> _lokasiTerdekat = [
//     {
//       'nama': 'BSU RW 01 Desa Bojongsoang',
//       'alamat': 'Jl. Sukapura, Di depan Kantor RW Bojongsoang, Kab.Bandung, Jawa Barat, 40257',
//     },
//     {
//       'nama': 'BSU RW 02 Desa Bojongsoang',
//       'alamat': 'Jl. Sukapura No.5, Kab.Bandung, Jawa Barat, 40258',
//     },
//     {
//       'nama': 'BSU RW 03 Desa Bojongsoang',
//       'alamat': 'Jl. Sukapura No.10, Kab.Bandung, Jawa Barat, 40259',
//     },
//   ];

//   static const CameraPosition _initialPosition = CameraPosition(
//     target: LatLng(-6.9345, 107.6239), // Koordinat Kabupaten Bandung
//     zoom: 13.0,
//   );

//   @override
//   void initState() {
//     super.initState();
//     _addMarkers();
//   }

//   void _addMarkers() {
//     _markers.add(
//       Marker(
//         markerId: MarkerId('BSU1'),
//         position: LatLng(-6.9363, 107.6261), // Lokasi BSU RW 01
//         infoWindow: InfoWindow(title: 'BSU RW 01 Desa Bojongsoang'),
//       ),
//     );
//     _markers.add(
//       Marker(
//         markerId: MarkerId('BSU2'),
//         position: LatLng(-6.9375, 107.6282), // Lokasi BSU RW 02
//         infoWindow: InfoWindow(title: 'BSU RW 02 Desa Bojongsoang'),
//       ),
//     );
//     _markers.add(
//       Marker(
//         markerId: MarkerId('BSU3'),
//         position: LatLng(-6.9387, 107.6293), // Lokasi BSU RW 03
//         infoWindow: InfoWindow(title: 'BSU RW 03 Desa Bojongsoang'),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lokasi Penyetoran'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             flex: 2,
//             child: GoogleMap(
//               onMapCreated: (controller) => _mapController = controller,
//               initialCameraPosition: _initialPosition,
//               markers: Set<Marker>.of(_markers),
//               zoomControlsEnabled: false,
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: ListView.builder(
//               itemCount: _lokasiTerdekat.length,
//               itemBuilder: (context, index) {
//                 final lokasi = _lokasiTerdekat[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: ListTile(
//                     leading: Icon(Icons.location_on, color: Colors.blue),
//                     title: Text(lokasi['nama']!),
//                     subtitle: Text(lokasi['alamat']!),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
