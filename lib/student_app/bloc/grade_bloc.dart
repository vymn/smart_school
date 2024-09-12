import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/grade.dart';
import '../model/course.dart';

part 'grade_event.dart';
part 'grade_state.dart';

class GradeBloc extends Bloc<GradeEvent, GradeState> {
  GradeBloc() : super(GradeInitial()) {
    on<GradeEvent>((event, emit) async {
      if (event is GetGradesEvent) {
        emit(GradeLoading());
        final result = await getGrades();
        emit(GradeLoaded(clinics: result));
        print(result);
      }
    });
  }
}

Future<List<Grade>> getGrades() async {
  final result = await FirebaseFirestore.instance.collection('classes').get();
  return result.docs
      .map((doc) => Grade(name: doc['className'], id: doc.id))
      .toList();
}
