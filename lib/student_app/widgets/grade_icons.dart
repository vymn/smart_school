import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/grade_bloc.dart';
import 'grade_icon.dart';

class GradesIcons extends StatelessWidget {
  const GradesIcons({
    super.key,
    // required this.clinics,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * .9;
    return BlocBuilder<GradeBloc, GradeState>(builder: (context, state) {
      if (state is GradeLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is GradeLoaded) {
        return SizedBox(
          width: width,
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var clinic in state.clinics)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GradeIcon(
                    id: clinic.id,
                    icon: Icons.book,
                    text: clinic.name,
                  ),
                )
            ],
          ),
        );
      } else {
        return const Center(
          child: Text('there is no clinics available'),
        );
      }
    });
  }
}
