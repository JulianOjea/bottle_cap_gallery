import 'package:flutter/material.dart';
import 'package:bottle_cap_gallery/src/views/ui/collection_view.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => CollectionView(),
  };
}
  