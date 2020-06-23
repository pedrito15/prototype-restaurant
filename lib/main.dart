import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:prototype_restaurant/src/pages/floor_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle.light.copyWith( // Por si hay un fondo transparente
      statusBarColor: Colors.transparent
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Prototype',
      initialRoute: 'floor_page',
      routes: {
        'floor_page' : (BuildContext context ) => FloorPage(),
      },
    );
  }
}