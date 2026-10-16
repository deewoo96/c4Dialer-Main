import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Utils/app_colors.dart';

class ContainerShimmerWidget extends StatefulWidget {
  final double height;
  const ContainerShimmerWidget({super.key,required this.height});

  @override
  State<ContainerShimmerWidget> createState() => _ContainerShimmerWidgetState();
}

class _ContainerShimmerWidgetState extends State<ContainerShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.whiteColor,
      highlightColor: AppColors.whiteBlur1Color,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: Colors.blue[100], borderRadius: BorderRadius.circular(3)),
      ),
    );
  }
}

class CircleAvatarShimmerWidget extends StatefulWidget {
  final double width,height;
  const CircleAvatarShimmerWidget({
    super.key,
    required this.width,
    required this.height
  });

  @override
  State<CircleAvatarShimmerWidget> createState() => _CircleAvatarShimmerWidgetState();
}

class _CircleAvatarShimmerWidgetState extends State<CircleAvatarShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.whiteBlur1Color,
      highlightColor: AppColors.shimmerLightColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(100)),
          ),
        ],
      ),
    );
  }
}

