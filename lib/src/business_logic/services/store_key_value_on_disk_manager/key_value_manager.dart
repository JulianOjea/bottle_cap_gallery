import 'dart:convert';

import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueManager {
  save(String key, Item value) async {
    print("Adding an item to disk");
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key)!);
  }
}
