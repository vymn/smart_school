import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school/core/constants/colors.dart';
import 'package:school/firebase_options.dart';
import 'package:school/student_app/screens/start_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (_, ch) => Directionality(
        textDirection: TextDirection.rtl,
        child: ch!,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: EgoColors.primaryColor,
        fontFamily: GoogleFonts.tajawal().fontFamily,
      ),
      home: const StartHomePage(),
    );
  }
}
