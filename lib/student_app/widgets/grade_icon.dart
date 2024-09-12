import 'package:smart_school/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/course_bloc.dart';

class GradeIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final String id;

  const GradeIcon({
    super.key,
    required this.icon,
    required this.text,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color(0xff6f75e1),
      onTap: () {
        context.read<CoursesBloc>().add(GetCoursesByGradeId(clinicId: id));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xfff5f3fe),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                color: EgoColors.primaryColor,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                color: EgoColors.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
