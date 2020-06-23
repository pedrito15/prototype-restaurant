
import 'dart:convert';

import 'package:prototype_restaurant/entities/table.dart';

class Floor{

  String floorId;
  List<TableRestaurant> tables;

  Floor({this.floorId, this.tables});

  factory Floor.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['tables'] as List;
    //print(list.runtimeType);
    List<TableRestaurant> tableList = list.map((i) => TableRestaurant.fromJson(i)).toList();

    return Floor(
      floorId:parsedJson['floorId'],
      tables:tableList
    );
  }

  Map<String, dynamic> toJson() => {
      'floorId':floorId,
      'tables': tables
  };

}