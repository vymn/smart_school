import 'package:smart_school/student_app/screens/home_screen.dart';
import 'package:smart_school/teacher_app/teacher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/common/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passowrdController;
  final _keyForm = GlobalKey<FormState>();
  bool isChangeSuffixIcon = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passowrdController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _emailController.dispose();
    _passowrdController.clear();
    _passowrdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
              top: -171,
              left: 23,
              // right: 23,
              child: Container(
                width: 496,
                height: 496,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(320),
                  border: Border.all(
                      color: const Color(0xffF8F9FF),
                      style: BorderStyle.solid,
                      width: 4),
                  color: Colors.white,
                ),
              )),
          Positioned(
              top: -356,
              // left: 0,
              right: -356,
              child: Container(
                width: 635,
                height: 635,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(320),
                    color: const Color(
                      0xffF8F9FF,
                    )),
              )),
          Positioned(
            bottom: -306,
            // left: 0,
            left: -356,
            child: Container(
              width: 496,
              height: 496,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(320),
                border: Border.all(
                    color: const Color(0xffF8F9FF),
                    style: BorderStyle.solid,
                    width: 4),
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 97),
            child: Form(
              key: _keyForm,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: EgoText(
                        text: 'مرحبا',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1F41BB)),
                  ),
                  const SizedBox(height: 30),
                  const Center(
                      child: SizedBox(
                    height: 70,
                    width: 225,
                    child: Column(
                      children: [
                        EgoText(
                          text: 'للمتابعه الرجاء',
                          // maxLines: ,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.visible,
                        ),
                        EgoText(
                          text: 'قم بتسجيل الدخول',
                          maxLines: 2,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 74),
                  EgoTextForm(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    // validator: validatedEmail,
                    hintText: 'إدخل بريدك الالكتروني',
                    prefixIcon: const Icon(Icons.alternate_email_rounded),
                  ),
                  const SizedBox(height: 20),
                  EgoTextForm(
                    controller: _passowrdController,
                    isPassword: isChangeSuffixIcon,
                    hintText: 'إدخل كلمه المرور',
                    prefixIcon: const Icon(Icons.password_rounded),
                    // validator: passwordValidator,
                  ),
                  const SizedBox(height: 40),
                  const Align(
                    alignment: Alignment.bottomRight,
                  ),
                  const SizedBox(height: 30),
                  EgoButton(
                    text: 'تسجيل الدخول',
                    width: size.width,
                    backgroundColor: const Color(0xff1F41BB),
                    fontSize: 18,
                    isTitle: true,
                    fontWeight: FontWeight.w600,
                    onPressed: () async {
                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passowrdController.text,
                        );
                        if (isTeacher(userCredential.user)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SelectClassScreen()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                              //     BlocProvider<CoursesBloc>(
                              //   create: (cnx) => CoursesBloc(),
                              //   child: const HomeScreen(),
                              // ),
                            ),
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

bool isTeacher(User? user) {
  // Logic to determine if the user is a teacher based on Firestore or claims
  return user != null && user.email!.endsWith('@school.com');
}
