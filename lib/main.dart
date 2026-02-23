import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/authentication/views/login_view.dart';

void main() {
  runApp(const UniformAdminApp());
}

class UniformAdminApp extends StatelessWidget {
  const UniformAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Uniform Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        primarySwatch: Colors.orange,
      ),
      home: const LoginView(),

      getPages: [
        GetPage(name: '/login', page: () => const LoginView()),
      ],
    );
  }
}
