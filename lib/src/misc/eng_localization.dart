import 'dart:convert';

import 'package:flutter/services.dart';

class EngLocalization {
  static Map<String, String>? data;

  static Future<void> load() async {
    String jsonString = await rootBundle
        .loadString('packages/country_code_picker/i18n/en.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    data = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  EngLocalization._();
}
