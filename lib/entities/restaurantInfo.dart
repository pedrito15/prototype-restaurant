import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'floor.dart';
import 'dart:convert';

import 'package:prototype_restaurant/src/modules/file_methods.dart';
import 'package:prototype_restaurant/entities/table.dart';

class RestaurantInfo{ // Este objeto será persistente

  List<Floor> listFloor = [];  // Propiedad que indique las mesas
  int floorIndex = 0;

  List<TableRestaurant> tables = [];

  static final RestaurantInfo _singleton = new RestaurantInfo._internal();

  factory RestaurantInfo() {
    return _singleton;
  }

  RestaurantInfo._internal();

  // Cargar la listFloor al inicializar
  getFloors() async{
    
    try {
      var file = await localFile;

      if(await file.exists() == false){ // Si no existe entonces escribir el documento
        
        // Cargar la info de json y escribirla en un archivo
        //String data = await DefaultAssetBundle.of(context).loadString("assets/data.json");
        String data = await rootBundle.loadString("assets/data.json");
        
        // Volver a asignar el archivo
        file = await writeData(data);
      }

      // Read the file.
      String contents = await file.readAsString();

      if(listFloor.length == 0){ // Si esta vacia la lista entonces llenar

        var showData=json.decode(contents);
        var list = showData['floors'] as List;

        listFloor = list.map((i) => Floor.fromJson(i)).toList();
        tables = listFloor[floorIndex].tables;
      }

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }

  // Cambiar las mesas dependiendo del piso que se muestre
  switchTables(int index){
    
    floorIndex = index;

    tables = listFloor[floorIndex].tables;
  }

  // Obtener una determinada mesa (para que sea mostrada)
  TableRestaurant getTable(int tableId){

    return tables[tableId];
  }

  // Guardar los datos del restaurante
  saveRestaurantData(){

    writeData(jsonEncode(this));  // Como decodificar el objeto mismo, llamar al objeto mismo ???
  }

  // Resetear
  resetRestaurantData(){

    // Borrar la lista
    listFloor.clear();

    deleteData();

    getFloors();
  }


  Map<String, dynamic> toJson() => {  // Para convertir este objeto en 'Json'
      'floors': listFloor
  };
}