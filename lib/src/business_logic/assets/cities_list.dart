import 'package:bottle_cap_gallery/src/business_logic/assets/list_iface.dart';
import 'package:flutter/cupertino.dart';

class CitiesService implements PretictiveListDataManager {
  final List<String> dataList = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];

  List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(dataList);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
