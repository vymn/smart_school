import 'dart:math';

import 'package:smart_school/core/constants/colors.dart';
import 'package:flutter/material.dart';

class BookWidget extends StatelessWidget {
  final String subject;

  const BookWidget({required this.subject, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Book body
        Container(
          padding: const EdgeInsets.only(left: 0, right: 3, top: 0, bottom: 0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300, // Book cover color
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            // width: 200,
            // height: 500,
            decoration: BoxDecoration(
              color: EgoColors.primaryColor.withOpacity(.8), // Book color
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Subject container color
                        borderRadius: BorderRadius.circular(5),
                      ),
                      // child: Text(
                      //   subject,
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 130,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Subject container color
                        borderRadius: BorderRadius.circular(5),
                      ),
                      // child: Text(
                      //   subject,
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 120,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Subject container color
                        borderRadius: BorderRadius.circular(5),
                      ),

                      // child: Text(
                      //   subject,
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ),
                    const Spacer(),
                    Center(
                      child: Text(
                        subject,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )
                  ]),
            ),
          ),
        ),
        // Bookmark on top
        Positioned(
          top: 0,
          right: 10,
          child: Container(
            width: 30,
            height: 50,
            decoration: BoxDecoration(
              color: getRandomColor(), // Bookmark color
              borderRadius: const BorderRadius.only(
                // topLeft: Radius.circular(10),
                // topRight: Radius.circular(10),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Color getRandomColor() {
  final random = Random();
  return Color.fromRGBO(
    random.nextInt(256), // Red value (0-255)
    random.nextInt(256), // Green value (0-255)
    random.nextInt(256), // Blue value (0-255)
    1, // Opacity (1 for fully opaque)
  );
}
