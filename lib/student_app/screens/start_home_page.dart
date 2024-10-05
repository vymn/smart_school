import 'package:school/core/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../login_screen.dart';
import '../../core/common/widgets/widgets.dart';

class StartHomePage extends StatelessWidget {
  const StartHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: EgoColors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 15.0),
                      EgoText(
                          text: 'مدرسه الزهراء اساس',
                          isTitle: true,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      EgoText(
                          text: 'نبتغي صيد المعالي نبتغي رأس الهرم',
                          fontSize: 16,
                          isTitle: true,
                          color: Colors.white70),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 30.0),
                      EgoButton(
                          text: 'تسجيل الدخول',
                          isTitle: true,
                          height: 55,
                          fontSize: 18,
                          border: 60,
                          fontWeight: FontWeight.w600,
                          colorText: Colors.black87,
                          backgroundColor: const Color(0xFFE9EFF9),
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen())),
                          width: size.width),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
