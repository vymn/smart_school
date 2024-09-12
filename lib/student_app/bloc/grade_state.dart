part of 'grade_bloc.dart';

@immutable
sealed class GradeState {}

final class GradeInitial extends GradeState {}

final class GradeLoading extends GradeState {}

final class GradeLoaded extends GradeState {
  final List<Grade> clinics;

  GradeLoaded({required this.clinics});
}

final class GradeCourseLaoding extends GradeState {}

final class GradesCoursesLoaded extends GradeState {
  final List<Course> doctors;
  GradesCoursesLoaded({required this.doctors});
}
