import 'package:flutter/material.dart';
import '../Utils/app_colors.dart';

class RestartAppWidget extends StatefulWidget {
  const RestartAppWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartAppWidgetState>()?.restartApp();
  }

  @override
  _RestartAppWidgetState createState() => _RestartAppWidgetState();
}

class _RestartAppWidgetState extends State<RestartAppWidget> {
  bool restarting = false;

  void restartApp() async {
    restarting = true;   // restart variable is set to true
    setState(() {});
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      setState(() {
        restarting = false; //restart variable is set to false
      });
    });
    // setState(() {
    //   key = UniqueKey();
    // });
  }

  @override
  Widget build(BuildContext context) {
    if (restarting) {
      return Container(
        color: AppColors.whiteColor,
          child: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor,)
        ),
      );
    }
    return SizedBox(
      child: widget.child,
    );
  }
}