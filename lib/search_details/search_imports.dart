import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_string.dart';
import '../Utils/utils.dart';
import '../widgets/category_hughes_number_button.dart';
import '../widgets/category_whatsapp_button.dart';
import '../widgets/horizontal_vertical_shimmer_widget.dart';
import '../widgets/profile_widget.dart';
import '../widgets/text_widget.dart';

part 's_s_sheet_plates_coils_screen1.dart';
part 's_s_sheet_plates_coils_screen2.dart';
part 's_s_sheet_plates_coils_screen3.dart';
part 's_s_sheet_plates_coils_screen4.dart';
part 'zero_point_one_mm_screen.dart';
part 'aluminium_screen.dart';
part 'all_thickness_screen.dart';
part 'angle_screen.dart';
part 'bush_road_screen.dart';
part 'copper_and_brass_screen1.dart';
part 'copper_and_brass_screen2.dart';
part 'copper_and_brass_screen3.dart';
part 'copper_and_brass_screen4.dart';
part 'eight_mm_screen.dart';
part 'exotic_metals_screen1.dart';
part 'exotic_metals_screen2.dart';
part 'exotic_metals_screen3.dart';
part 'fittings_screen1.dart';
part 'fittings_screen2.dart';
part 'fittings_screen3.dart';
part 'flanges_screen.dart';
part 'forge_items_screen.dart';
part 'furniture_items_screen.dart';
part 'mild_screen1.dart';
part 'mild_screen2.dart';
part 'mild_screen3.dart';
part 'mild_screen4.dart';
part 'mild_screen5.dart';
part 'wire_road_screen.dart';
part 'scrap_screen.dart';
part 'ms_fasteners_screen.dart';
part 'pipes_and_tubes_screen1.dart';
part 'pipes_and_tubes_screen2.dart';
part 'pipes_and_tubes_screen3.dart';
part 'pipes_and_tubes_screen4.dart';
part 'pipes_and_tubes_screen5.dart';
part 'pipes_and_tubes_screen6.dart';
part 'pipes_and_tubes_screen7.dart';
part 'pipes_and_tubes_screen8.dart';
part 'roads_and_bard_screen1.dart';
part 'roads_and_bard_screen2.dart';
part 'roads_and_bard_screen3.dart';
part 'roads_and_bard_screen4.dart';
part 'rolling_screen.dart';

num? categoryPremiumValue(Map<dynamic, dynamic> user) =>
    num.tryParse(user["premium"]?.toString() ?? "");

List<Map<dynamic, dynamic>> sortCategoryUsersAlphabetically(
  List<Map<dynamic, dynamic>> users,
) {
  final indexedUsers = users.indexed.toList();
  indexedUsers.sort((first, second) {
    final firstPremium = categoryPremiumValue(first.$2);
    final secondPremium = categoryPremiumValue(second.$2);
    if (firstPremium == null && secondPremium != null) return 1;
    if (firstPremium != null && secondPremium == null) return -1;
    if (firstPremium != null && secondPremium != null) {
      final premiumOrder = firstPremium.compareTo(secondPremium);
      if (premiumOrder != 0) return premiumOrder;
    }

    final firstName = first.$2["companyName"]?.toString().trim() ?? "";
    final secondName = second.$2["companyName"]?.toString().trim() ?? "";
    final nameOrder = firstName.toLowerCase().compareTo(
          secondName.toLowerCase(),
        );
    return nameOrder != 0 ? nameOrder : first.$1.compareTo(second.$1);
  });
  return indexedUsers.map((entry) => entry.$2).toList();
}
