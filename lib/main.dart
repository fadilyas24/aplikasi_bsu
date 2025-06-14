import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/pages/activity_pages.dart';
import 'package:aplikasi_bsu/ui/pages/admin_add_savings.dart';
import 'package:aplikasi_bsu/ui/pages/admin_add_savings_bluetooth_page.dart';
import 'package:aplikasi_bsu/ui/pages/admin_add_savings_success_page.dart';
import 'package:aplikasi_bsu/ui/pages/admin_homepage.dart';
import 'package:aplikasi_bsu/ui/pages/admin_login.dart';
import 'package:aplikasi_bsu/ui/pages/admin_manage_user_page.dart';
import 'package:aplikasi_bsu/ui/pages/admin_profile_page.dart';
import 'package:aplikasi_bsu/ui/pages/admin_user_data.dart';
import 'package:aplikasi_bsu/ui/pages/change_password.dart';
import 'package:aplikasi_bsu/ui/pages/edit_profile.dart';
import 'package:aplikasi_bsu/ui/pages/home_page.dart';
// import 'package:aplikasi_bsu/ui/pages/lokasi_penyetoran_page.dart';
import 'package:aplikasi_bsu/ui/pages/main_page.dart';
import 'package:aplikasi_bsu/ui/pages/notification_page.dart';
import 'package:aplikasi_bsu/ui/pages/pin_page.dart';
import 'package:aplikasi_bsu/ui/pages/poin_redeem_success_page.dart';
import 'package:aplikasi_bsu/ui/pages/profile_page.dart';
import 'package:aplikasi_bsu/ui/pages/redeem_poin_page.dart';
import 'package:aplikasi_bsu/ui/pages/sign_in_page.dart';
import 'package:aplikasi_bsu/ui/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/date_symbol_data_local.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null); // <-- inisialisasi locale
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: lightColor,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: blackColor),
          backgroundColor: lightColor,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      routes: {
        '/': (context) => SignInPage(),
        '/admin-login': (context) => AdminLoginPage(),
        '/sign-up': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/main-home': (context) => MainPage(),
        '/notification': (context) => NotificationsPage(),
        '/profile': (context) => ProfilePage(),
        '/activity': (context) => ActivityPage(),
        '/edit-profile': (context) => EditProfilePage(),
        '/redeem-poin': (context) => RedeemPointPage(),
        '/pin': (context) => PinPage(),
        '/redeem-success': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return PoinRedeemSuccessPage(
            productName: args['productName'],
            pointsUsed: args['pointsUsed'],
            currentDate: args['currentDate'],
          );
        },
        '/main-admin': (context) => MainAdmin(),
        '/admin-manage-user': (context) => AdminManageUser(),
        '/admin-user-data': (context) {
          final userData = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return AdminUserData(userData: userData);
        },
        '/admin-add-savings': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return AdminAddSavings(
              userId: args['userId']); // Mengambil userId dari arguments
        },
        '/admin-add-savings-iot': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return AddSavingsWithBluetoothPage(userId: args['userId']);
        },
        '/admin-add-savings-success': (context) => AdminAddSavingsSuccessPage(),
        '/admin-profile': (context) => AdminProfilePage(),
        '/change-password': (context) => ChangePasswordScreen(),
        // '/lokasi-penyetoran': (context) => LokasiPenyetoranPage(),
      },
    );
  }
}
