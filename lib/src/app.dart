import 'package:bottle_cap_gallery/src/routes/routes.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Collection(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: '/',
        routes: getApplicationRoutes(),
        theme: ThemeData(
          primaryColor: Colors.green,
          //canvasColor: Color.fromARGB(255, 189, 139, 156),
          canvasColor: Colors.white,
          textTheme: const TextTheme(
              bodyText1: TextStyle(color: Colors.green),
              bodyText2: TextStyle(color: Colors.black, fontSize: 20)),
        ),
      ),
    );
  }
}
