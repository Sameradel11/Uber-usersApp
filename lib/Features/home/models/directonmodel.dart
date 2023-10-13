// ignore_for_file: public_member_api_docs, sort_constructors_first
class DirectionModel {
  int  distancevalue;
  String distancetext;
  int durationvalue;
  String durationtext;
  String epoints;
  DirectionModel({
    required this.distancevalue,
    required this.distancetext,
    required this.durationvalue,
    required this.durationtext,
    required this.epoints,
  });

  factory DirectionModel.fromjson(jsondata) {
    return DirectionModel(
      distancevalue: jsondata['routes'][0]['legs'][0]['distance']['value'],
      distancetext: jsondata['routes'][0]['legs'][0]['distance']['text'],
      durationvalue: jsondata['routes'][0]['legs'][0]['duration']['value'],
      durationtext: jsondata['routes'][0]['legs'][0]['duration']['text'],
      epoints: jsondata['routes'][0]['overview_polyline']['points'],
    );
  }
}
