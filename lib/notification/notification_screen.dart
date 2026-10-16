import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_string.dart';
import '../Utils/common_widgets.dart';
import 'notification_provider.dart';

class NotificationScreen extends StatefulWidget {
  final String id ;
  const NotificationScreen({super.key , required this.id});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationStream = Provider.of<NotificationProvider>(context);
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
                "Notifications",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w900,
                    color: AppColors.blackColor
                )),
            Container(padding: const EdgeInsets.only(left:10), child: Image.asset(AppString.appTitleLogo,width: 100)),
          ],
        ),
      ),
      body: SizedBox(
        width: isTablet(context) ? screenWidth(context) * 0.6 : null,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DatabaseEvent>(
                stream: notificationStream.notificationStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                    return const Center(child: Text('No notifications found'));
                  }

                  Map<dynamic, dynamic> notifications =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List<Map<dynamic, dynamic>> notificationList = notifications.entries
                      .map((entry) => Map<dynamic, dynamic>.from(entry.value))
                      .toList();

                  // Sort notifications by timestamp in descending order (latest first)
                  notificationList.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));


                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: notificationList.length,
                    itemBuilder: (context, index) {
                      final notification = notificationList[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                notification['imageUrl'] != null ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(imageUrl: notification['imageUrl'], width: 45,fit: BoxFit.cover)) :
                                Image.asset(AppString.bellImg,width: 45),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      textWidgets(
                                        title: notification['title'],
                                        fontSize: isTablet(context) ? 16 : screenWidth(context) * 0.041,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textWidgets(
                                        title: notification['body'],
                                        fontSize: isTablet(context) ? 15 : screenWidth(context) * 0.033,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.blackColor.withValues(alpha: 0.8),maxLines: 5,
                                        overflow: TextOverflow.ellipsis
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                textWidgets(
                                    title: notificationStream.formatTimestamp(notification['timestamp']),
                                    fontSize: isTablet(context) ? 14 : screenWidth(context) * 0.03,
                                    fontWeight: FontWeight.w500,color: AppColors.blackColor.withValues(alpha: 0.4),maxLines: 5, overflow: TextOverflow.ellipsis
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(color: AppColors.whiteBlur4Color);
                    },
                  );
                },
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}

// Name:C4Dialer
// Key ID:H82C8D3H55
// Services:Apple Push Notifications service (APNs)

// Modify App Capabilities
// Adding or removing any capabilities will invalidate any provisioning profiles that include this App ID and they must be regenerated for future use.