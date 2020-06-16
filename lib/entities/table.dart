import 'package:flutter/material.dart';

class TableRestaurant extends StatelessWidget{

  int tableId;
  String tableType;
  String tableName;
  int capacity;
  String status;

  TableRestaurant({ this.tableId, this.tableType, this.tableName, this.capacity, this.status });

  factory TableRestaurant.fromJson(Map<String, dynamic> parsedJson){

    return TableRestaurant(
      tableId:parsedJson['tableId'],
      tableType:parsedJson['tableType'],
      tableName:parsedJson['tableName'],
      capacity:parsedJson['capacity'],
      status:parsedJson['status']
    );
  }

  Map<String, dynamic> toJson() => {

      // Iterar cada elemento para convertirlo a json
      'tableId':tableId,
      'tableType':tableType,
      'tableName':tableName,
      'capacity':capacity,
      'status':status
  };

  Widget build(BuildContext context) { 

    var color = Colors.green;

     switch (status) {
       case "busy":     color = Colors.red;  break;
       case "disabled": color = Colors.grey; break;
     }


      // Dibujar tipo de mesa
     if(tableType == "square"){

       return _squareTable(tableName, color, capacity);

     }else{ // Es circular

      return _roundTable(tableName, color, capacity);
     }
  }
}

 Widget _squareTable(String name, Color color, int capacity){

    return ClipRRect(
      
      child: Container(
        width: 55,
        height: 55.0,
        margin: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox( height: 5.0 ),
            Text( name , style: TextStyle( color: Colors.white )),
            SizedBox( height: 5.0 ),
            Text( capacity.toString() , style: TextStyle( color: Colors.white )),
          ],
        ),

      ),
    );
  }

  Widget _roundTable(String name, Color color, int capacity){

    return ClipOval(

      child: Container(
        
        width: 60,
        height: 60.0,
        margin: EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox( height: 5.0 ),
            Text( name , style: TextStyle( color: Colors.white )),
            SizedBox( height: 5.0 ),
            Text( capacity.toString() , style: TextStyle( color: Colors.white )),
          ],
        ),

      ),
    );
  }