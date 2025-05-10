import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

/// A custom text field with various configurations
///
/// This text field supports regular input, password input, phone number input,
/// and search bar styling
class CustomTextField extends StatelessWidget {
  /// Creates a custom text field
  ///
  /// [hintText] is the hint text to display when the field is empty
  /// [autofocus] determines if the field should be focused when displayed
  /// [maxLines] is the maximum number of lines for the field
  /// [minLines] is the minimum number of lines for the field
  /// [maxLength] is the maximum number of characters allowed
  /// [onSaved] is called when the form is saved
  /// [validator] is used to validate the input
  /// [onFieldSubmitted] is called when the field is submitted
  /// [onChanged] is called when the text changes
  /// [controller] is the controller for the text field
  /// [textInputType] is the keyboard type for the field
  /// [title] is the label text above the field
  /// [isRequired] indicates if the field is required
  /// [isPassword] indicates if the field is for password input
  /// [isPhoneNumber] indicates if the field is for phone number input
  /// [isSearchBar] indicates if the field is styled as a search bar
  /// [obscureText] indicates if the text should be obscured
  /// [suffixIcon] is the icon to display at the end of the field
  /// [suffixIconSize] is the size of the suffix icon
  /// [prefixIcon] is the icon to display at the start of the field
  /// [onSuffixTap] is called when the suffix icon is tapped
  /// [prefixIconSize] is the size of the prefix icon
  /// [onCountryChanged] is called when the country is changed in phone input
  const CustomTextField({
    super.key,
    this.hintText,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.controller,
    this.onSaved,
    this.validator,
    this.autofocus = false,
    this.textInputType,
    this.onFieldSubmitted,
    this.title,
    this.isRequired = false,
    this.isPassword = false,
    this.isPhoneNumber = false,
    this.isSearchBar = false,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.suffixIconSize = 24,
    this.prefixIconSize = 24,
    this.onChanged,
    this.onSuffixTap,
    this.onCountryChanged,
  });

  final String? hintText;
  final bool autofocus;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final String? title;
  final bool isRequired;
  final bool isPassword;
  final bool isPhoneNumber;
  final bool isSearchBar;
  final bool obscureText;
  final HeroIcons? suffixIcon;
  final double suffixIconSize;
  final HeroIcons? prefixIcon;
  final void Function()? onSuffixTap;
  final double prefixIconSize;
  final void Function(Country)? onCountryChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = 13.sp;
    final paddingSize = 10.w;
    final spacingHeight = 8.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSearchBar)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (isRequired)
                  TextSpan(
                    text: '*',
                    style: GoogleFonts.poppins(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        if (!isSearchBar) SizedBox(height: spacingHeight),
        if (!isPhoneNumber)
          TextFormField(
            controller: controller,
            onChanged: onChanged,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.secondary,
            ),
            maxLength: maxLength,
            maxLines: maxLines,
            minLines: minLines,
            keyboardType: textInputType,
            obscureText: obscureText,
            enableSuggestions: !isPassword,
            autocorrect: !isPassword,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: isSearchBar
                  ? EdgeInsets.symmetric(vertical: paddingSize)
                  : null,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: onSuffixTap ?? () {},
                      icon: HeroIcon(
                        suffixIcon!,
                        size: suffixIconSize,
                      ),
                    )
                  : null,
              prefixIcon: prefixIcon != null
                  ? IconButton(
                      onPressed: () {},
                      icon: HeroIcon(
                        prefixIcon!,
                        size: prefixIconSize,
                      ),
                    )
                  : null,
            ),
            // Custom validator for text field
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autofocus: autofocus,
            onSaved: onSaved,
            onFieldSubmitted: onFieldSubmitted,
          )
        else
          IntlPhoneField(
            controller: controller,
            autofocus: autofocus,
            initialCountryCode: 'US',
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
            flagsButtonPadding: EdgeInsets.only(left: paddingSize),
            dropdownTextStyle: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
            ),
            onCountryChanged: onCountryChanged,
            // Phone field has its own validator type
            validator: (phone) {
              if (validator != null && phone?.number != null) {
                return validator!(phone!.number);
              }
              return null;
            },
          ),
      ],
    );
  }
}
