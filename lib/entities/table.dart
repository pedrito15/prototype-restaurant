import 'package:flutter/material.dart';
import 'package:prototype_restaurant/entities/restaurantInfo.dart';

class TableRestaurant extends StatefulWidget {
  
  int tableId;
  String tableType;
  String tableName;
  int capacity;
  String status;
  Offset position = Offset(0, 0);

  TableRestaurant({ this.tableId, this.tableType, this.tableName, this.capacity, this.status, this.position});


  factory TableRestaurant.fromJson(Map<String, dynamic> parsedJson){

    // Decodificar
    var coordenadas = parsedJson['position'];
    double posX = coordenadas['posX'];
    double posY = coordenadas['posY'];

    return TableRestaurant(
      tableId:parsedJson['tableId'],
      tableType:parsedJson['tableType'],
      tableName:parsedJson['tableName'],
      capacity:parsedJson['capacity'],
      status:parsedJson['status'],
      position: Offset(posX, posY),
    );
  }

  Map<String, dynamic> toJson() => {

      // Iterar cada elemento para convertirlo a json
      'tableId':tableId,
      'tableType':tableType,
      'tableName':tableName,
      'capacity':capacity,
      'status':status,
      'position': {"posX": position.dx, "posY": position.dy}
  };


  @override
  _TableRestaurantState createState() => _TableRestaurantState();
}

class _TableRestaurantState extends State<TableRestaurant>{

  Color tableColor;  // 'available' por defecto
  Widget tableShape;
  bool isDragged = false;

  double left;
  double top;

  @override
  Widget build(BuildContext context) {

    switch (widget.status) {
      case "available": tableColor = Colors.green; break;
      case "disabled" : tableColor = Colors.grey;  break;
      case "busy"     : tableColor = Colors.red;   break;
    }

    // Determinar la forma de la mesa
    if(widget.tableType == "square"){
      tableShape = _squareTable(widget.tableName, tableColor, widget.capacity);

    }else{
      tableShape = _roundTable(widget.tableName, tableColor, widget.capacity);
    }

    //return tableShape;

    return Positioned(
      left: widget.position.dx,
      top:  widget.position.dy,
      child: Draggable(
        data: tableColor,
        child: _getTable(
          size: 57, 
          color: tableColor, 
          textStyle: TextStyle( color: Colors.white)
        ),
        onDragStarted:(){
          setState(() { 
            isDragged = true;
          });
        },
        onDraggableCanceled: (velocity, offset) {
          setState(() {

            isDragged = false;
            
            double limitX = MediaQuery.of(context).size.width - 57;       // 57 por el tamaño de la mesa
            double limitY = MediaQuery.of(context).size.height - 100 - 57; // 90 por el tamaño de bottom bar y 57 por el tamaño de la mesa

            //print("limitY: $limitY");
            double posX;
            double posY;

            if(offset.dx < -6.5){
              posX = -6.5;
            }else if(offset.dx > limitX){
              posX = limitX;
            }else{
              posX = offset.dx;
            }

            if(offset.dy < 100){  // Aqui difiere debido al margen de la appBar (la posición es respecto a la appBar, mientras que el offset toma en cuenta toda la pantalla)
              posY = 0;
            }else if(offset.dy > limitY){
              posY = limitY - 100;
            }else{
              posY = offset.dy - 100;
            }


            widget.position = Offset(posX, posY); 


            // Guardar las posiciones de las mesas
            var restaurantInfo = new RestaurantInfo();
            restaurantInfo.saveRestaurantData();
          });
        },
        feedback: _getTable(
          size: 57, 
          color: tableColor.withOpacity(0.5), 
          textStyle: TextStyle( color: Colors.white, fontSize: 14, decoration: TextDecoration.none )
        ),
      )
    );
  }


  Widget _getTable({double size, Color color, TextStyle textStyle}){

    if(widget.tableType == "square"){ // MESA CUADRADA
      
      return ClipRRect(
        
        child: Container(
          width: size,
          height: size,
          margin: EdgeInsets.all(7.0),
          decoration: BoxDecoration(
            color: color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox( height: 5.0 ),
              Text( widget.tableName, style: textStyle),
              SizedBox( height: 5.0 ),
              Text( widget.capacity.toString() , style: textStyle),
            ],
          ),

        ),
      );

    }else{ // MESA REDONDA
      
      return ClipOval(

        child: Container(
          width: size,
          height: size,
          margin: EdgeInsets.all(7.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox( height: 5.0 ),
              Text( widget.tableName, style: textStyle),
              SizedBox( height: 5.0 ),
              Text( widget.capacity.toString(), style: textStyle),
            ],
          ),

        ),
      );
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
              Text( name, style: TextStyle( color: Colors.white )),
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
}


