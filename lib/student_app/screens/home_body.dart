import 'package:school/student_app/bloc/grade_bloc.dart';
import 'package:school/student_app/bloc/course_bloc.dart';
import 'package:school/student_app/widgets/book.dart';
import 'package:school/student_app/screens/course_detials_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/grade_icons.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    context.read<GradeBloc>().add(const GetGradesEvent());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 10,
            ),
            const GradesIcons(),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'المواد الدراسيه',
              style: TextStyle(
                  color: Color(0xff151a56),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocConsumer<CoursesBloc, CoursesState>(
              builder: (context, state) {
                if (state is CoursesInitial) {
                  return const Center(
                    child: Text('ألرجاء اختيار السنه الدراسيه'),
                  );
                }
                if (state is CoursesLoading || state is CoursesInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CoursesLoaded) {
                  if (state.courses.isEmpty) {
                    return const Center(
                      child: Text(
                          'لا يوجد مواد في هذه السنه الدراسيه الرجاء اختيار سنه اخري'),
                    );
                  }

                  return SizedBox(
                      // padding: EdgeInsets.only(bottom: 50),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .62,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Two categories per row
                            crossAxisSpacing: 10.0, // Space between columns
                            mainAxisSpacing: 10.0, // Space between rows
                            childAspectRatio: 1.5 /
                                2, // Adjust to control the width-to-height ratio
                          ),
                          padding: const EdgeInsets.all(10),
                          itemCount: state.courses.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // context.read<CoursesBloc>().add(GetCourseById(doctors[index].id));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailsScreen(
                                      classId: state.classId,
                                      course: state.courses[index],
                                    ),
                                  ),
                                );
                              },
                              child: BookWidget(
                                  subject: state.courses[index].title),
                            );
                          }));
                  // return CoursesScreen(doctors: state.doctors);
                }
                return const SizedBox();
              },
              listener: (BuildContext context, CoursesState state) {
                if (state is CoursesInitial) {
                  context.read<CoursesBloc>().add(const GetAllCoursesEvent());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
