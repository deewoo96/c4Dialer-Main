import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Utils/app_colors.dart';


class ProfileShimmerWidget extends StatefulWidget {
  double widthRatio, heightRatio;
  ProfileShimmerWidget({
    super.key,
    required this.heightRatio,
    required this.widthRatio,
  });

  @override
  State<ProfileShimmerWidget> createState() => _ProfileShimmerWidgetState();
}

class _ProfileShimmerWidgetState extends State<ProfileShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Shimmer.fromColors(
      baseColor: AppColors.whiteBlur1Color,
      highlightColor: AppColors.shimmerLightColor,
      child:  SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            CircleAvatar(
              radius: 50,
                backgroundColor:  Colors.blue[300],
            ),
            const SizedBox(height: 5,),
            Container(
              width: screenWidth * 0.6,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:Colors.blue[300],
              ),
            ),
            const SizedBox(height: 3,),
            Container(
              width: screenWidth * 0.5,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:Colors.blue[300],
              ),
            ),
            const SizedBox(height: 3,),
            Container(
              width: screenWidth * 0.4,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:Colors.blue[300],
              ),
            ),
            const SizedBox(height: 3,),
            Container(
              width: screenWidth * 0.2,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:Colors.blue[300],
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return  Container(
                      margin: EdgeInsets.only(
                        bottom:  MediaQuery.of(context).size.width * 0.02,
                        right:  MediaQuery.of(context).size.width * 0.02,
                        left:  MediaQuery.of(context).size.width * 0.02,
                      ),
                      width: widget.widthRatio,
                      height: widget.heightRatio,
                      decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(2)
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

