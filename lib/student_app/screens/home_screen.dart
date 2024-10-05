import 'package:school/core/constants/colors.dart';
import 'package:school/student_app/bloc/course_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/grade_bloc.dart';
import 'home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EgoColors.primaryColor,
        title: const Text(
          'الزهراء اساس',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: MultiBlocProvider(
        providers: [
          BlocProvider<GradeBloc>(create: (_) => GradeBloc()),
          BlocProvider<CoursesBloc>(create: (_) => CoursesBloc()),
        ],
        child: const HomeBody(),
      )),
    );
  }
}
