import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_school/core/constants/colors.dart';
import 'package:smart_school/firebase_options.dart';
import 'package:smart_school/student_app/screens/start_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await seedFirestore();
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

Future<void> seedFirestore() async {
  // Reference to Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Sample data
  List<Map<String, dynamic>> data = [
    {
      'classId': '1',
      'className': 'First Grade',
      'subjects': [
        {
          'subjectId': 'math',
          'subjectName': 'Mathematics',
          'lessons': [
            {
              'lessonId': 'lesson_1',
              'title': 'Introduction to Addition',
              'description': 'Basic concepts of addition',
              'videoUrl':
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            },
            {
              'lessonId': 'lesson_2',
              'title': 'Subtraction Basics',
              'description': 'Understanding subtraction',
              'videoUrl':
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            }
          ]
        },
        {
          'subjectId': 'science',
          'subjectName': 'Science',
          'lessons': [
            {
              'lessonId': 'lesson_1',
              'title': 'Introduction to Plants',
              'description': 'Basics of plant biology',
              'videoUrl':
                  'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            }
          ]
        }
      ]
    },
    {
      'classId': '2',
      'className': 'Second Grade',
      'subjects': [
        {
          'subjectId': 'math',
          'subjectName': 'Mathematics',
          'lessons': [
            {
              'lessonId': 'lesson_1',
              'title': 'Multiplication Basics',
              'description': 'Learning multiplication',
              'videoUrl': 'https://sample-videos.com/video126.mp4',
            }
          ]
        }
      ]
    }
  ];

  try {
    // Iterate through each class and add to Firestore
    for (var classData in data) {
      // Create class document
      DocumentReference classRef =
          firestore.collection('classes').doc(classData['classId']);
      await classRef.set({
        'className': classData['className'],
      });

      // Iterate through subjects
      for (var subjectData in classData['subjects']) {
        // Create subject document
        DocumentReference subjectRef =
            classRef.collection('subjects').doc(subjectData['subjectId']);
        await subjectRef.set({
          'subjectName': subjectData['subjectName'],
        });

        // Iterate through lessons
        for (var lessonData in subjectData['lessons']) {
          // Create lesson document
          DocumentReference lessonRef =
              subjectRef.collection('lessons').doc(lessonData['lessonId']);
          await lessonRef.set({
            'title': lessonData['title'],
            'description': lessonData['description'],
            'videoUrl': lessonData['videoUrl'],
          });
        }
      }
    }
    print('Seeding completed successfully');
  } catch (e) {
    print('Error seeding Firestore: $e');
  }
}
