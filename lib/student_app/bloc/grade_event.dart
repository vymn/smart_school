part of 'grade_bloc.dart';

@immutable
sealed class GradeEvent {
  const GradeEvent();
}

class GetGradesEvent extends GradeEvent {
  const GetGradesEvent();
}
