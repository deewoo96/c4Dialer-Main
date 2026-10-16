import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Utils/app_colors.dart';
import '../Utils/common_widgets.dart';

class HorizontalVerticalShimmerWidget extends StatefulWidget {
  // final double widthRatio, heightRatio;
  const HorizontalVerticalShimmerWidget({
    super.key,
   // required this.heightRatio,
   // required this.widthRatio,
   });

  @override
  State<HorizontalVerticalShimmerWidget> createState() => _HorizontalVerticalShimmerWidgetState();
}

class _HorizontalVerticalShimmerWidgetState extends State<HorizontalVerticalShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Shimmer.fromColors(
        baseColor: AppColors.whiteBlur1Color,
        highlightColor: AppColors.shimmerLightColor,
        child:  SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 10,
                            width: screenWidth(context) * 0.3,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          const SizedBox(height: 6,),
                          Container(
                            height: 10,
                            width: screenWidth(context) * 0.7,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.more_vert_outlined,color: Theme.of(context).primaryColor,)
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}

