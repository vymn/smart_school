import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school/core/common/widgets/widgets.dart';
import 'package:school/core/functions/helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../core/constants/colors.dart';

class SelectClassScreen extends StatelessWidget {
  const SelectClassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: EgoColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "أختر السنه الدراسيه",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('classes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          var classes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  classes[index]['className'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SelectSubjectScreen(classes[index].id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SelectSubjectScreen extends StatelessWidget {
  final String classId;
  const SelectSubjectScreen(this.classId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: EgoColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "أختر اسم الماده",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('classes')
            .doc(classId)
            .collection('subjects')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          var subjects = snapshot.data!.docs;
          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  subjects[index]['subjectName'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UploadLessonScreen(classId, subjects[index].id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UploadLessonScreen extends StatefulWidget {
  final String classId;
  final String subjectId;

  const UploadLessonScreen(this.classId, this.subjectId, {super.key});

  @override
  _UploadLessonScreenState createState() => _UploadLessonScreenState();
}

class _UploadLessonScreenState extends State<UploadLessonScreen> {
  List<File> _videos = [];
  List<String> _titles = [];

  Future<void> _pickVideos() async {
    // Pick multiple videos from the file picker
    // Use a package like file_picker or image_picker
    // Use file_picker to select multiple video files
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _videos = result.files.map((file) {
          return File(file.path!);
        }).toList();
        _titles = List.generate(_videos.length, (_) => '');
      });
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'], // Allow document files
      allowMultiple: true,
    );

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      _uploadCheatSheets(files);
    }
  }

  Future<void> _uploadVideos() async {
    for (String title in _titles) {
      if (title.isEmpty) {
        // Handle empty titles
        errorMessageSnack(context, 'الرجاء كتابة عنوان الدرس/الدروس', null);
        return;
      }
    }
    if (_videos.length != _titles.length) {
      // Handle the mismatch between videos and titles
      print('Error: The number of titles and videos do not match.');
      return;
    }

    setState(() {
      isUploading = true;
    });
    for (int i = 0; i < _videos.length; i++) {
      String fileName = _videos[i].path.split('/').last;

      // Upload video to Firebase Storage
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref(
              'classes/${widget.classId}/subjects/${widget.subjectId}/videos/$fileName')
          .putFile(_videos[i]);

      String videoUrl = await snapshot.ref.getDownloadURL();

      // Save the lesson title and video URL in Firestore
      await FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('subjects')
          .doc(widget.subjectId)
          .collection('lessons')
          .add({
        'title': _titles[i],
        'videoUrl': videoUrl,
      });
      setState(() {
        isUploading = false;
      });
      errorMessageSnack(context, 'تم رفع الحصه بنجاح', Colors.green);
      _videos = [];
      _titles = [];
    }
  }

  Future<void> _uploadCheatSheets(List<File> files) async {
    setState(() {
      isUploading = true;
    });
    for (int i = 0; i < files.length; i++) {
      String fileName = files[i].path.split('/').last;
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref(
              'classes/${widget.classId}/subjects/${widget.subjectId}/cheat_sheets/$fileName')
          .putFile(files[i]);

      String fileUrl = await snapshot.ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection('classes')
          .doc(widget.classId)
          .collection('subjects')
          .doc(widget.subjectId)
          .collection('cheat_sheets')
          .add({
        'fileName': fileName,
        'fileUrl': fileUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    setState(() {
      isUploading = false;
    });
    errorMessageSnack(context, 'تم رفع اوراق العمل بنجاح', Colors.green);
    _videos = [];
    _titles = [];
  }

  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: EgoColors.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "رفع الحصص",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                  visible: _videos.isEmpty,
                  child: Container(
                    // height: 560,
                    child: Center(
                      child: EgoButton(
                        text: 'ارفع الحصص',
                        width: 320,
                        onPressed: _pickVideos,
                      ),
                    ),
                  )),
              const SizedBox(
                height: 8,
              ),
              Visibility(
                  visible: _videos.isEmpty,
                  child: Container(
                    // height: 560,
                    child: Center(
                      child: isUploading
                          ? const CircularProgressIndicator()
                          : EgoButton(
                              text: 'ارفع اوراق العمل',
                              width: 320,
                              onPressed: _pickFiles,
                            ),
                    ),
                  )),
              // ElevatedButton(
              //   onPressed: _pickVideos,
              //   child: Text("Pick Videos"),
              // ),
              Expanded(
                child: ListView.builder(
                  itemCount: _videos.length,
                  itemBuilder: (context, index) {
                    print(index);
                    return ListTile(
                      title: TextField(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15.0),
                          filled: true,
                          fillColor: const Color(0xffF1F4FF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Color(0xff1F41BB),
                              // color: EgoColors.primaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              // color: Color(0xff1F41BB),
                              color: EgoColors.primaryColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              // color: Color(0xff1F41BB),
                              color: EgoColors.primaryColor,
                            ),
                          ),
                          labelText: 'عنوان الحصه',
                        ),
                        onChanged: (val) {
                          if (index < 0 || index >= _titles.length) {
                            print('Error: Index $index is out of bounds.');
                            return;
                          }
                          setState(() {
                            _titles[index] = val;
                          });
                        },
                      ),
                      // title: EgoTextForm(controller: controller),
                      // title: TextField(
                      //   decoration: InputDecoration(hintText: 'Lesson Title'),
                      //   onChanged: (val) {
                      //     if (index < 0 || index >= _titles.length) {
                      //       print('Error: Index $index is out of bounds.');
                      //       return;
                      //     }
                      //     setState(() {
                      //       _titles[index] = val;
                      //     });
                      //   },
                      // ),
                      subtitle: Text(_videos[index].path.split('/').last),
                    );
                  },
                ),
              ),
              Visibility(
                visible: _videos.isNotEmpty,
                child: isUploading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : EgoButton(
                        text: 'تحميل الحصص',
                        width: 320,
                        onPressed: _uploadVideos,
                      ),
              ),
              // ElevatedButton(
              //   onPressed: _uploadVideos,
              //   child: Text("Upload Videos"),
              // ),
            ],
          ),
        ));
  }
}
