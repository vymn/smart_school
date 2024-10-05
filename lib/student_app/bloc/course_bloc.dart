import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school/student_app/model/course.dart';
import 'package:meta/meta.dart';

part 'course_event.dart';
part 'course_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc() : super(CoursesInitial()) {
    on<CoursesEvent>((event, emit) async {
      if (event is GetCoursesByGradeId) {
        print('im in the get clinic by id');
        emit(CoursesLoading());
        final result = await getGradeCourses(classId: event.clinicId);
        print(result);
        emit(CoursesLoaded(courses: result, classId: event.clinicId));
        print(result);
      }
    });
  }
}

Future<List<Course>> getGradeCourses({required String classId}) async {
  try {
    print('fetchig courses!!!!!!!!!!!!!!');
    // Fetch the subjects for the specific class
    final subjectCollection = FirebaseFirestore.instance
        .collection('classes')
        .doc(classId) // Specify the class by its ID
        .collection('subjects');

    final snapshot = await subjectCollection.get();
    print('this is the snap shot: $snapshot');
    if (snapshot.docs.isEmpty) {
      // No subjects found
      print('No Subjects found!!!!!!!!!!!!!!!!!!!!');
      return [];
    }

    // Fetch lessons for each subject
    final courses = await Future.wait(snapshot.docs.map((doc) async {
      final data = doc.data();

      // Fetch lessons for this subject
      final lessonCollection = FirebaseFirestore.instance
          .collection('classes')
          .doc(classId)
          .collection('subjects')
          .doc(doc.id)
          .collection('lessons');

      final lessonSnapshot = await lessonCollection.get();
      final lessons = lessonSnapshot.docs.map((lessonDoc) {
        final lessonData = lessonDoc.data();
        return Lesson.fromMap(lessonData);
      }).toList();

      print('lessonssssssssss: $lessons');
      return Course(
        id: doc.id,
        title: data['subjectName'] ?? '',
        lessons: lessons,
      );
    }).toList());

    print('couessdfsdfsadkflasdfjskld: $courses');
    return courses;
  } catch (e) {
    print('Error fetching subjects: $e');
    // Handle the error or rethrow
    return [];
  }
}
