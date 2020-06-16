

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:prototype_restaurant/entities/restaurantInfo.dart';
import 'package:prototype_restaurant/src/modules/file_methods.dart';

import 'package:reorderables/reorderables.dart';

import 'package:prototype_restaurant/entities/floor.dart';


class FloorPage extends StatefulWidget {
  
  @override
  _FloorPageState createState() => _FloorPageState();
}

class _FloorPageState  extends State<FloorPage> {
  
  int currentIndex = 0;
  String title = "Main Floor";

  List<Floor> listFloor = [];
  List<Widget> _tiles = [];

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

                 setState(() { // Actualizar vista

                  // vaciar las listas
                  listFloor.clear();
                  _tiles.clear();

                  // Resetear el archivo
                  deleteData();
                });
              },
            ),
          ]
        ),
      body: Container(
        decoration: new BoxDecoration(color: Color.fromRGBO(119, 127, 234, 1)),
          child: Center(
            child: FutureBuilder(
              future: readData(),
              builder: (context, snapshot){

                var wrap = ReorderableWrap(
                  maxMainAxisCount: (_tiles.length / 2).floor(),
                  spacing: 5.0,
                  runSpacing: 4.0,
                  padding: const EdgeInsets.all(8),
                  children: _tiles,
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {

                      //Widget row = _tiles.removeAt(oldIndex);
                      _tiles.insert(newIndex, _tiles.removeAt(oldIndex));

                      RestaurantInfo info = new RestaurantInfo(listFloor: listFloor);
                      
                      print(jsonEncode(info)); // Con el jsonEncode hace que todos las propiedades anidadas llamen al método 'toJson()'
                      writeData(jsonEncode(info));
                    });
                  },
                  onNoReorder: (int index) {
                    //this callback is optional
                    debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
                  },
                  onReorderStarted: (int index) {
                    //this callback is optional
                    debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
                  }
                );

                
                // Se despliegan las mesas
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    wrap,
                  ],
                );
              }
            ),

        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(context)
    );
  }

// - - - - - - - - - - - - - - - LEER DATOS DE JSON - - - - - - - - - - - - - - - - - - - - - - -

  Future<String> readData() async {
  try {
    var file = await localFile;

    if(await file.exists() == false){ // Si no existe entonces escribir el documento
      
      // Cargar la info de json y escribirla en un archivo
      String data = await DefaultAssetBundle.of(context).loadString("assets/data.json");
      
      // Volver a asignar el archivo
      file = await writeData(data);
    }

    // Read the file.
    String contents = await file.readAsString();

    var showData=json.decode(contents);
    var list = showData['floors'] as List;

    listFloor = list.map((i) => Floor.fromJson(i)).toList();
    _tiles = listFloor[currentIndex].tables;

    return contents;
  } catch (e) {
    // If encountering an error, return 0.
    return null;
  }
}
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

  Widget _bottomNavigationBar(BuildContext context) {

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,  // Con esto se pueden ver los items si tengo más de tres
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index; 

          _tiles = listFloor[currentIndex].tables;  // Actualizar datos que se muestran en pantalla

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