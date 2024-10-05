import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:school/core/constants/colors.dart';
import 'package:school/student_app/widgets/lesson_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../model/course.dart';

class DetailsScreen extends StatefulWidget {
  final String classId;
  final Course course;
  const DetailsScreen({
    super.key,
    required this.course,
    required this.classId,
  });

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int _selectedTag = 0;

  void changeTab(int index) {
    setState(() {
      _selectedTag = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: EgoColors.primaryColor,
          title: Text(
            widget.course.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                const SizedBox(
                  height: 3,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTabView(
                  index: _selectedTag,
                  changeTab: changeTab,
                ),
                _selectedTag == 0
                    ? PlayList(
                        course: widget.course,
                        classId: widget.classId,
                      )
                    : CheatSheet(
                        classId: widget.classId,
                        course: widget.course,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlayList extends StatelessWidget {
  final String classId;
  final Course course;
  const PlayList({super.key, required this.course, required this.classId});

  @override
  Widget build(BuildContext context) {
    print('course: $course');
    print('classId: $classId');
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('classes')
            .doc(classId)
            .collection('subjects')
            .doc(course.id)
            .collection('lessons')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text(
              'لا يوجد حصص في هذه الماده',
            );
          } else {
            print("this is me: ${snapshot.data!.docs}");
            print('course: ${course.id}');
            print('classId: $classId');
            List<Lesson> lessons = snapshot.data!.docs
                .map((doc) => Lesson.fromMap(doc.data()))
                .toList();
            return Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                shrinkWrap: true,
                itemCount: lessons.length,
                itemBuilder: (_, index) {
                  print(lessons);
                  return LessonCard(lesson: lessons[index]);
                },
              ),
            );
          }
        });
  }
}

class CheatSheet extends StatelessWidget {
  final String classId;
  final Course course;
  const CheatSheet({super.key, required this.classId, required this.course});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('classes')
            .doc(classId)
            .collection('subjects')
            .doc(course.id)
            .collection('cheat_sheets')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          var cheatSheets = snapshot.data!.docs;

          return SizedBox(
            height: MediaQuery.of(context).size.height * .7,
            child: ListView.builder(
              itemCount: cheatSheets.length,
              itemBuilder: (context, index) {
                var cheatSheet = cheatSheets[index].data();
                return ListTile(
                  title: Text(
                    cheatSheet['fileName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    downloadFile(cheatSheet['fileUrl'], cheatSheet['fileName'],
                        context); // Call the download function
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CustomTabView extends StatefulWidget {
  final Function(int) changeTab;
  final int index;
  const CustomTabView(
      {super.key, required this.changeTab, required this.index});

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  final List<String> _tags = ["الحصص", "الاوراق"];

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        widget.changeTab(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .08, vertical: 15),
        decoration: BoxDecoration(
          color: widget.index == index ? EgoColors.primaryColor : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _tags[index],
          style: TextStyle(
              color: widget.index != index ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _tags
            .asMap()
            .entries
            .map((MapEntry map) => _buildTags(map.key))
            .toList(),
      ),
    );
  }
}

class EnrollBottomSheet extends StatefulWidget {
  const EnrollBottomSheet({super.key});

  @override
  _EnrollBottomSheetState createState() => _EnrollBottomSheetState();
}

class _EnrollBottomSheetState extends State<EnrollBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Row(
        children: [
          CustomIconButton(
            onTap: () {},
            height: 45,
            width: 45,
            child: const Icon(
              Icons.favorite,
              color: Colors.pink,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: CustomIconButton(
              onTap: () {},
              color: EgoColors.primaryColor,
              height: 45,
              width: 45,
              child: const Text(
                "Enroll Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final Color? color;
  final VoidCallback onTap;

  const CustomIconButton({
    super.key,
    required this.child,
    required this.height,
    required this.width,
    this.color = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 2.0,
            spreadRadius: .05,
          ), //BoxShadow
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(child: child),
      ),
    );
  }
}

Future<void> downloadFile(
    String fileUrl, String fileName, BuildContext context) async {
  Dio dio = Dio();
  String savePath = await _getFilePath(fileName);

  OverlayEntry? overlayEntry;

  try {
    // Create and show the initial overlay with the progress indicator
    overlayEntry = _createOverlayEntry(context, 0.0);
    Overlay.of(context).insert(overlayEntry);

    await dio.download(
      fileUrl,
      savePath,
      onReceiveProgress: (receivedBytes, totalBytes) {
        if (totalBytes != -1) {
          double progress = receivedBytes / totalBytes;

          // Remove the old overlay and create a new one with updated progress
          overlayEntry?.remove();
          overlayEntry = _createOverlayEntry(context, progress);
          Overlay.of(context).insert(overlayEntry!);
        }
      },
    );

    // Download completed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم التحميل بنجاح: $fileName')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('هناك مشكله في تحميل الملف: $e')),
    );
  } finally {
    // Remove the overlay once the download is done or if an error occurs
    overlayEntry?.remove();
  }
}

// Helper function to get the file path for saving
Future<String> _getFilePath(String fileName) async {
  Directory directory = await getApplicationDocumentsDirectory();
  return "${directory.path}/$fileName";
}

// Create an overlay entry with the progress indicator
OverlayEntry _createOverlayEntry(BuildContext context, double progress) {
  return OverlayEntry(
    builder: (context) => _progressOverlay(context, progress),
  );
}

// Progress indicator UI
Widget _progressOverlay(BuildContext context, double progress) {
  return Positioned(
    top: MediaQuery.of(context).size.height * 0.4,
    left: MediaQuery.of(context).size.width * 0.25,
    child: Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7), // Slightly transparent black
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "تحميل...",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 16),
            Text(
              "${(progress * 100).toStringAsFixed(0)}%",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}
