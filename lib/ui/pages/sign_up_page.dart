import 'package:aplikasi_bsu/shared/theme.dart';
import 'package:aplikasi_bsu/ui/pages/sign_in_page.dart';
// import 'package:flutter/material.dart';

import '../widget/buttons.dart';
import '../widget/forms.dart';

// class SignUpPage extends StatelessWidget {
//   const SignUpPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: lightColor,
//       body: ListView(
//         padding: EdgeInsets.symmetric(horizontal: edge),
//         children: [
//           Container(
//             width: 151,
//             height: 75,
//             margin: EdgeInsets.only(
//               top: 40,
//               bottom: 25,
//             ),
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/logo_bsu.png'),
//               ),
//             ),
//           ),
//           Text(
//             'Ayo Daftar &\nSetorkan Sampahmu',
//             style: blackTextStyle.copyWith(
//                 fontSize: 18, fontWeight: FontWeight.w700),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               color: whiteColor,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //NAME INPUT
//                 CustomFormField(
//                   title: 'Nama Lengkap',
//                   formHintText: 'Masukkan nama lengkap anda',
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 //EMAIL INPUT
//                 CustomFormField(
//                   title: 'Email',
//                   formHintText: 'Masukkan email anda',
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 //PASSWORD INPUT
//                 CustomFormField(
//                   title: 'Password',
//                   formHintText: 'Masukkan password Anda',
//                   obscureText: true,
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 // KONFIRMASI PASSWORD INPUT
//                 CustomFormField(
//                   title: 'Konfirmasi Password',
//                   formHintText: 'Konfirmasi password Anda',
//                   obscureText: true,
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 CustomFilledButton(
//                   title: 'Daftar',
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/main-home');
//                   },
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Sudah memiliki akun?',
//                       style: regularTextStyle,
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => SignInPage()));
//                       },
//                       child: Text(
//                         'Masuk',
//                         style: regularTextStyle.copyWith(
//                             color: blueColor, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  Future<void> registerUser(BuildContext context, String fullName, String email,
      String password) async {
    const String url =
        'http://192.168.1.9:5000/user/signup'; // Ubah sesuai URL API Flask Anda

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'full_name': fullName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      print('User registered successfully');
      // Mengarahkan pengguna ke halaman homepage
      Navigator.pushNamed(context, '/');
    } else {
      print('Failed to register user: ${response.body}');
      // Menampilkan pesan pop-up jika pendaftaran gagal
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pendaftaran Gagal'),
            content: Text('Pendaftaran akun gagal. Silakan coba lagi.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      backgroundColor: lightColor,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: edge),
        children: [
          Container(
            width: 151,
            height: 75,
            margin: EdgeInsets.only(
              top: 40,
              bottom: 25,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/logo_bsu.png'),
              ),
            ),
          ),
          Text(
            'Ayo Daftar &\nSetorkan Sampahmu',
            style: blackTextStyle.copyWith(
                fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //NAME INPUT
                CustomFormField(
                  title: 'Nama Lengkap',
                  formHintText: 'Masukkan nama lengkap anda',
                  controller: fullNameController,
                ),
                SizedBox(
                  height: 16,
                ),
                //EMAIL INPUT
                CustomFormField(
                  title: 'Email',
                  formHintText: 'Masukkan email anda',
                  controller: emailController,
                ),
                SizedBox(
                  height: 16,
                ),
                //PASSWORD INPUT
                CustomFormField(
                  title: 'Password',
                  formHintText: 'Masukkan password Anda',
                  obscureText: true,
                  controller: passwordController,
                ),
                SizedBox(
                  height: 16,
                ),
                // KONFIRMASI PASSWORD INPUT
                CustomFormField(
                  title: 'Konfirmasi Password',
                  formHintText: 'Konfirmasi password Anda',
                  obscureText: true,
                  controller: confirmPasswordController,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomFilledButton(
                  title: 'Daftar',
                  onPressed: () async {
                    if (passwordController.text ==
                        confirmPasswordController.text) {
                      await registerUser(
                        context,
                        fullNameController.text,
                        emailController.text,
                        passwordController.text,
                      );
                    } else {
                      print('Password tidak cocok');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password tidak cocok')),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah memiliki akun?',
                      style: regularTextStyle,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()));
                      },
                      child: Text(
                        'Masuk',
                        style: regularTextStyle.copyWith(
                            color: blueColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}











          // Widget lainnya
//           CustomFormField(
//             title: 'Nama Lengkap',
//             formHintText: 'Masukkan nama lengkap anda',
//             controller: fullNameController,
//           ),
//           CustomFormField(
//             title: 'Email',
//             formHintText: 'Masukkan email anda',
//             controller: emailController,
//           ),
//           CustomFormField(
//             title: 'Password',
//             formHintText: 'Masukkan password Anda',
//             obscureText: true,
//             controller: passwordController,
//           ),
//           CustomFormField(
//             title: 'Konfirmasi Password',
//             formHintText: 'Konfirmasi password Anda',
//             obscureText: true,
//             controller: confirmPasswordController,
//           ),
//           SizedBox(
//             height: 30,
//           ),
//           CustomFilledButton(
//             title: 'Daftar',
//             onPressed: () async {
//               if (passwordController.text == confirmPasswordController.text) {
//                 await registerUser(
//                   context,
//                   fullNameController.text,
//                   emailController.text,
//                   passwordController.text,
//                 );
//               } else {
//                 print('Password tidak cocok');
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Password tidak cocok')),
//                 );
//               }
//             },
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Sudah memiliki akun?',
//                 style: regularTextStyle,
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => SignInPage()));
//                 },
//                 child: Text(
//                   'Masuk',
//                   style: regularTextStyle.copyWith(
//                       color: blueColor, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
