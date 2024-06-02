import 'package:aplikasi_bsu/ui/widget/admin_user_card.dart';
import 'package:aplikasi_bsu/ui/widget/forms.dart';
import 'package:flutter/material.dart';

import '../../shared/theme.dart';

class AdminManageUser extends StatelessWidget {
  const AdminManageUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Nasabah'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: edge),
        child: ListView(
          children:  [
            const CustomFormField(
              title: '',
              formHintText: 'Cari Nasabah',
            ),
            const SizedBox(height: 20),
            AdminUserCard(
              name: 'Jack Sparrow',
              email: 'jackseparo@gmail.com',
              onTap: () {
                Navigator.pushNamed(context, '/admin-user-data');
              },
            ),
            const AdminUserCard(
              name: 'Jack Sparrow',
              email: 'jackseparo@gmail.com',
            ),
            const AdminUserCard(
              name: 'Jack Sparrow',
              email: 'jackseparo@gmail.com',
            ),
            const AdminUserCard(
              name: 'Jack Sparrow',
              email: 'jackseparo@gmail.com',
            ),
            const AdminUserCard(
              name: 'Jack Sparrow',
              email: 'jackseparo@gmail.com',
            ),
            const AdminUserCard(
              name: 'Jack Sparrow',
              email: 'jackseparo@gmail.com',
            ),
          ],
        ),
      ),
    );
  }
}
