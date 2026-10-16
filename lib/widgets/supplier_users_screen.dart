import 'package:flutter/material.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_string.dart';
import 'category_hughes_number_button.dart';
import 'profile_widget.dart';
import 'text_widget.dart';

class SupplierUsersScreen extends StatelessWidget {
  const SupplierUsersScreen({
    super.key,
    required this.users,
  });

  final List<Map<dynamic, dynamic>> users;

  void _openProfile(BuildContext context, Map<dynamic, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileWidget(
          appBarTitle: item["companyName"] ?? "",
          companyAddress: item["companyDetails"] ?? "",
          companyName: item["companyName"] ?? "",
          firstPhoneNumber: item["phoneNumber"] ?? "",
          secondPhoneNumber: item["phoneNumber1"] ?? "",
          selectedCategory: item["categorySelected"] ?? "",
          websiteUrl: item["url"] ?? "",
          firstHughesNumber: item["hughesNumber"] ?? "",
          secondHughesNumber: item["hughes2"] ?? "",
          thirdHughesNumber: item["hughes3"] ?? "",
          fourthHughesNumber: item["hughes4"] ?? "",
          productKeyword: item["productKeyword"] ?? "",
          name1: item["name"] ?? "",
          name2: item["name1"] ?? "",
          profileImageUrl: item["profileImageUrl"] ?? "",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          "USERS",
          style: TextStyle(
            color: AppColors.blackColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: users.isEmpty
          ? const Center(child: Text("No suppliers available"))
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: users.length,
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                final item = users[index];
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.whiteBlur1Color,
                  ),
                  child: ListTile(
                    onTap: () => _openProfile(context, item),
                    leading: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryColor,
                      backgroundImage: AssetImage(AppString.userImg),
                    ),
                    title: TextWidget(
                      color: AppColors.blackColor,
                      text: item["companyName"]?.toString() ?? "",
                      premium: item["premium"],
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    subtitle: Text(
                      item["categorySelected"]?.toString() ?? "Supplier",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: CategoryHughesNumberButton(
                      number: item["hughesNumber"]?.toString() ?? "",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
