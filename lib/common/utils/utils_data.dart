import 'dart:convert';

import 'package:actual/common/const/data.dart';

class UtilsData {
  static String pathToUrl(String path) => 'http://$ip$path';

  static List<String> listPathsToUrls(List paths) => paths.map((path) => pathToUrl(path)).toList();

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String encoded = stringToBase64.encode(plain);
    return encoded;
  }

  static DateTime stringToDateTime(String value) {
    final result = DateTime.tryParse(value);

    if (result == null) {
      print('stringToDateTime error: $value');
      return DateTime.now();
    }
    print('stringToDateTime success: $value');
    return result;
  }
}
