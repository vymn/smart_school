import 'package:smart_school/core/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

Route routeSlide({required Widget page, Curve curved = Curves.easeInOut}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) =>
        page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(parent: animation, curve: curved);

      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .animate(curvedAnimation),
        child: child,
      );
    },
  );
}

Route routeFade({required Widget page, Curve curved = Curves.easeInOut}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(parent: animation, curve: curved);

      return FadeTransition(
        opacity: curvedAnimation,
        child: child,
      );
    },
  );
}

void errorMessageSnack(BuildContext context, String error, Color? color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: EgoText(text: error, color: Colors.white),
      backgroundColor: color ?? Colors.red));
}

final validatedEmail = MultiValidator([
  RequiredValidator(errorText: 'Email ID is required'),
  EmailValidator(errorText: 'Enter a valid Email ID')
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'Password must be to least 8 digits long')
]);

final requiredValidator = RequiredValidator(errorText: 'مطلوب');
