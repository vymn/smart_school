part of 'widgets.dart';

class EgoTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;

  const EgoTextForm({
    super.key,
    required this.controller,
    this.prefixIcon,
    this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.getFont('Roboto', fontSize: 17),
      cursorColor: Color(0xff1F41BB),
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
          filled: true,
          fillColor: const Color(0xffF1F4FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Color(0xff1F41BB),
              // color: EgoColors.primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              // color: Color(0xff1F41BB),
              color: EgoColors.primaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              // color: Color(0xff1F41BB),
              color: EgoColors.primaryColor,
            ),
          ),
          hintText: hintText,
          prefixIcon: prefixIcon),
      validator: validator,
    );
  }
}
