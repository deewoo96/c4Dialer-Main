import 'package:flutter/material.dart';

import 'Utils/app_colors.dart';
import 'Utils/app_string.dart';

class PipesImageDetailsScreen extends StatefulWidget {
  const PipesImageDetailsScreen({super.key});

  @override
  State<PipesImageDetailsScreen> createState() => _PipesImageDetailsScreenState();
}

class _PipesImageDetailsScreenState extends State<PipesImageDetailsScreen> {
  String dropdownvalue = '20';
  var items = [
    '20',
    '40',
    '60',
    '80',
    '100',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_outlined,color: AppColors.black,)),
        elevation: 0,
        title: Row(
          children: [
            const Text(
                "C4Dialer",
                style: TextStyle(
                    fontSize: 22,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w900,
                    color: AppColors.blackColor
                )),
            Container(padding: const EdgeInsets.only(left:10), child: Image.asset(AppString.appTitleLogo,width: 100)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Stack(
                  children: [
                    Image.asset(AppString.pipeImg,),
                    Positioned(
                        top: 50,
                        left: 50,
                        child: Text(
                          dropdownvalue,
                          style: const TextStyle(color: AppColors.blueColor,fontSize: 20,fontWeight: FontWeight.bold),
                        )
                    ),
                    Positioned(
                        bottom: 50,
                        left: 130,
                        child: Text(
                          "${int.parse(dropdownvalue) * 8}",
                          style: const TextStyle(color: AppColors.blueColor,fontSize: 20,fontWeight: FontWeight.bold),
                        )
                    ),
                    Positioned(
                        top: 80,
                        right: 100,
                        child: Text(
                          "${int.parse(dropdownvalue) * 4}",
                          style: const TextStyle(color: AppColors.blueColor,fontSize: 20,fontWeight: FontWeight.bold),
                        )
                    ),
                  ]
              ),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 18 ),
                decoration: BoxDecoration(
                  color: AppColors.purpleDark,
                  border: Border.all(
                    color: AppColors.purpleDark,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: AppColors.greenColor,
                  ),
                  child: DropdownButton<String>(
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    style: const TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold),
                    underline: Container(height: 0,),
                    iconEnabledColor: AppColors.whiteColor,
                    value: dropdownvalue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
