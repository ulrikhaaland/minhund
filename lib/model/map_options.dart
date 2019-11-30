import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapOptions {
  MapOptions({this.placeCategories});
  List<PlaceCategory> placeCategories;
}

class PlaceCategory {
  PlaceCategory({this.colorIndex, this.selected, this.name, this.markers});
  bool selected;
  int colorIndex;
  String name;
  Set<Marker> markers;
}
