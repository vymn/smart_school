part of 'course_bloc.dart';

@immutable
sealed class CoursesEvent {
  const CoursesEvent();
}

final class GetAllCoursesEvent extends CoursesEvent {
  const GetAllCoursesEvent();
}

final class GetCoursesByGradeId extends CoursesEvent {
  final String clinicId;

  const GetCoursesByGradeId({required this.clinicId});
}

final class GetCourseById extends CoursesEvent {
  final String doctorId;

  const GetCourseById(this.doctorId);
}
