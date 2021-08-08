import 'package:bottle_cap_gallery/src/views/ui/collection_view.dart';

import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: ColectionView(),
    );
  }
}
