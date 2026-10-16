import 'package:flutter/material.dart';

import '../Utils/app_colors.dart';
import '../Utils/utils.dart';
import '../provider/category_provider.dart';

class CategoryHughesNumberButton extends StatelessWidget {
  const CategoryHughesNumberButton({
    super.key,
    required this.number,
  });

  final String number;

  String? get _fourDigitNumber =>
      RegExp(r'(?:^U_)?(\d{4})$', caseSensitive: false)
          .firstMatch(number.trim())
          ?.group(1);

  @override
  Widget build(BuildContext context) {
    final displayNumber = _fourDigitNumber ?? number;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 70),
      child: Material(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          highlightColor: const Color.fromARGB(255, 199, 199, 199),
          splashColor: const Color.fromARGB(255, 199, 199, 199),
          onTap: () async {
            final fourDigitNumber = _fourDigitNumber;
            if (fourDigitNumber == null) {
              Utils.flushBarErrorMessage(
                "Invalid Hughes number: $number",
                context,
              );
              return;
            }

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Calling $fourDigitNumber"),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            await PhoneCallClass.phoneNumberToCall(
              number: fourDigitNumber,
              context: context,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  displayNumber,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
