import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prototype_restaurant/entities/restaurantInfo.dart';
import 'package:prototype_restaurant/src/modules/file_methods.dart';


class FloorPage extends StatefulWidget {
  
  @override
  _FloorPageState createState() => _FloorPageState();
}

class _FloorPageState  extends State<FloorPage>{
  
  int currentIndex = 0;
  String title = "Main Floor";


  final restaurantInfo = new RestaurantInfo();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color.fromRGBO(95, 194, 148, 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {

              setState(() { // Resetear los datos
                
                restaurantInfo.resetRestaurantData();
              });
            
            },
          ),
        ]
      ),
      body: Container(
        decoration: new BoxDecoration(color: Color.fromRGBO(119, 127, 234, 1)),
          child: Center(
            child: FutureBuilder(
              future: restaurantInfo.getFloors(),
              builder: (context, snapshot){

                // Se despliegan las mesas
                return Stack(
                  children: <Widget>[
                    for(var i = 0; i < restaurantInfo.tables.length; i++)
                    restaurantInfo.tables[i]
                  ],
                );
              }
            ),
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(context)
    );
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  Widget _bottomNavigationBar(BuildContext context) {

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,  // Con esto se pueden ver los items si tengo más de tres
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index; 

          restaurantInfo.switchTables(currentIndex);  // Cambiar las mesas que se muestran en pantalla (dependiendo del piso que se seleccione)

          // Cambiar el titulo
          switch (index) {
            case 0: title = "Main Floor";  break;
            case 1: title = "Patio"; break;
            case 2: title = "Bar";   break;
            case 3: title = "Second Floor";  break;
          }
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon( Icons.restaurant ),
          title: Text('Main Floor'),
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.fastfood),
          title: Text('Patio')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.local_bar),
          title: Text('Bar')
        ),
        BottomNavigationBarItem(
          icon: Icon( Icons.local_cafe),
          title: Text('Second Floor')
        ),
      ],
    );

  }

}