import 'package:smart_school/student_app/bloc/video_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/video_screen.dart';
import '../model/course.dart';
import '../../core/icons.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  const LessonCard({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the videoPlayer screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (cnx) => VideoCubit(),
              child: VideoPlayerScreen(lesson.videoUrl),
            ),
          ),
        );
      },
      child: Row(
        children: [
          lesson.isPlaying!
              ? Image.asset(
                  icLearning,
                  height: 45,
                )
              : Image.asset(
                  icPlayNext,
                  height: 45,
                ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class Lesson {
//   String name;
//   String duration;
//   bool isPlaying;
//   bool isCompleted;
//
//   Lesson({
//     required this.duration,
//     required this.isCompleted,
//     required this.isPlaying,
//     required this.name,
//   });
// }

// List<Lesson> lessonList = [
//   Lesson(
//     duration: '11 min 20 sec',
//     isCompleted: true,
//     isPlaying: true,
//     name: "الحصه الاولي",
//   ),
//   Lesson(
//     duration: '10 min 11 sec',
//     isCompleted: false,
//     isPlaying: false,
//     name: "الحصه الثانيه",
//   ),
//   Lesson(
//     duration: '7 min',
//     isCompleted: false,
//     isPlaying: false,
//     name: "الحصه الثالثه",
//   ),
//   Lesson(
//     duration: '5 min',
//     isCompleted: false,
//     isPlaying: false,
//     name: "الحصه الرابعه",
//   ),
//   Lesson(
//     duration: '5 min',
//     isCompleted: false,
//     isPlaying: false,
//     name: "الحصه الخامسه",
//   ),
//   Lesson(
//     duration: '5 min',
//     isCompleted: false,
//     isPlaying: false,
//     name: "الحصة السادسه",
//   )
// ];
