part of 'course_bloc.dart';

@immutable
sealed class CoursesState {
  const CoursesState();
}

final class CoursesInitial extends CoursesState {}

class CoursesLoading extends CoursesState {}

class CoursesLoaded extends CoursesState {
  final List<Course> courses;
  final String classId;
  const CoursesLoaded({required this.courses, required this.classId});
}

class CourseLoading extends CoursesState {}

class CourseLoaded extends CoursesState {
  final Course doctor;
  const CourseLoaded({required this.doctor});
}
