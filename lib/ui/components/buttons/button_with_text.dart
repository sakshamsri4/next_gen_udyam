import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:next_gen/ui/components/buttons/custom_button.dart';

/// A button with text below it, commonly used for login/signup screens
///
/// This component combines a button with a text that has a tappable part
class ButtonWithText extends StatelessWidget {
  /// Creates a button with text below it
  ///
  /// [btnLabel] is the text to display on the button
  /// [firstTextSpan] is the first part of the text below the button
  /// [secondTextSpan] is the second part of the text below the button (tappable)
  /// [onTap] is the async function to call when the button is tapped
  /// [onTextTap] is the function to call when the second text span is tapped
  const ButtonWithText({
    required this.btnLabel,
    required this.firstTextSpan,
    required this.secondTextSpan,
    required this.onTap,
    required this.onTextTap,
    super.key,
  });

  /// The text to display on the button
  final String btnLabel;

  /// The first part of the text below the button
  final String firstTextSpan;

  /// The second part of the text below the button (tappable)
  final String secondTextSpan;

  /// The async function to call when the button is tapped
  final Future<void> Function() onTap;

  /// The function to call when the second text span is tapped
  final void Function() onTextTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textSize = 12.sp;
    final verticalSpacing = 20.h;

    return Column(
      children: [
        CustomButton(
          title: btnLabel,
          onTap: onTap,
        ),
        SizedBox(height: verticalSpacing),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: firstTextSpan,
                style: GoogleFonts.poppins(
                  fontSize: textSize,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextSpan(
                text: secondTextSpan,
                recognizer: TapGestureRecognizer()..onTap = onTextTap,
                style: GoogleFonts.poppins(
                  fontSize: textSize,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
