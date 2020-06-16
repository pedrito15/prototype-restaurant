import 'floor.dart';

class RestaurantInfo{

  List<Floor> listFloor;

  RestaurantInfo({this.listFloor});

  Map<String, dynamic> toJson() => {
      'floors': listFloor
  };
}