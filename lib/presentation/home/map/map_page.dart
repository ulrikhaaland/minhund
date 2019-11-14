import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'map-options/map_options_page.dart';

enum MapPageState { noCurrentLocation, map, options }

class MapPageController extends MasterPageController {
  static final MapPageController _instance = MapPageController._internal();

  factory MapPageController() {
    return _instance;
  }

  MapPageController._internal() {
    print("Map Page built");
  }

  Completer<GoogleMapController> mapController = Completer();

  LocationData currentLocation;

  Set<Marker> markers;

  Location location = new Location();

  MapPageState mapPageState = MapPageState.noCurrentLocation;

  @override
  void initState() {
    // List<Place> places = [
    //   Place(
    //       name: "Hundehjørnet",
    //       city: "Ski",
    //       lat: 59.734253,
    //       long: 10.818914,
    //       type: "park"),
    //   Place(
    //       name: "Frogn Hundepark",
    //       city: "Drøbak",
    //       lat: 59.675537,
    //       long: 10.639613,
    //       type: "park"),
    //   Place(
    //       name: "Solbergfoss Hundepark",
    //       city: "Spydeberg",
    //       lat: 59.635737,
    //       long: 11.150325,
    //       type: "park"),
    //   Place(
    //       name: "Skraperudtjern Hundepark",
    //       city: "Oslo",
    //       lat: 59.87097,
    //       long: 10.852909,
    //       type: "park"),
    //   Place(
    //       name: "Hundesletta Ekeberg",
    //       city: "Oslo",
    //       lat: 59.893821,
    //       long: 10.76627,
    //       type: "park"),
    //   Place(
    //       name: "Varden Hundepark",
    //       city: "Nesodden",
    //       lat: 59.840399,
    //       long: 10.648587,
    //       type: "park"),
    //   Place(
    //       name: "Ola Narr Hundepark",
    //       city: "Oslo",
    //       lat: 59.921923,
    //       long: 10.778897,
    //       type: "park"),
    //   Place(
    //       name: "Grefsenkollveien",
    //       city: "Oslo",
    //       lat: 59.964346,
    //       long: 10.801071,
    //       type: "park"),
    //   Place(
    //       name: "Hundejordet Maridalen",
    //       city: "Oslo",
    //       lat: 59.967878,
    //       long: 10.76538,
    //       type: "park"),
    //   Place(
    //       name: "Stensparken Hundehage",
    //       city: "Oslo",
    //       lat: 59.929106,
    //       long: 10.731685,
    //       type: "park"),
    //   Place(
    //       name: "Hundejordet Vigelandsparken",
    //       city: "Oslo",
    //       lat: 59.929337,
    //       long: 10.698706,
    //       type: "park"),
    //   Place(
    //       name: "Storøyodden hundepark",
    //       city: "Oslo",
    //       lat: 59.889728,
    //       long: 10.600496,
    //       type: "park"),
    //   Place(
    //       name: "Kjørbotangen hundepark",
    //       city: "Bærum",
    //       lat: 59.895785,
    //       long: 10.518909,
    //       type: "park"),
    //   Place(
    //       name: "Vøyenenga hundepark",
    //       city: "Bærum",
    //       lat: 59.910446,
    //       long: 10.484582,
    //       type: "park"),
    //   Place(
    //       name: "Hundejordet lillestrøm",
    //       city: "Lillestrøm",
    //       lat: 59.969595,
    //       long: 11.019415,
    //       type: "park"),
    //   Place(
    //       name: "Nuggerud",
    //       city: "Lørenskog",
    //       lat: 59.928652,
    //       long: 10.923024,
    //       type: "park"),
    // ];
    // places.forEach((place) {
    //   Firestore.instance.collection("places").add(place.toJson()).then((ref) {
    //     place.id = ref.documentID;
    //     ref.updateData({
    //       "id": place.id,
    //     });
    //   });
    // });
    getPlaces();
    getLocation();
    super.initState();
  }

  Future<void> getPlaces() async {
    markers = {};
    QuerySnapshot qSnap =
        await Firestore.instance.collection("places").getDocuments();
    for (DocumentSnapshot doc in qSnap.documents) {
      markers.add(Marker(
        markerId: MarkerId(doc.documentID),
        position: LatLng(doc.data["lat"], doc.data["long"]),
        infoWindow: InfoWindow(title: doc.data["name"] + " (Hundepark)"),
      ));
    }
    setState(() {});
  }

  Future<void> getLocation() async {
    try {
      currentLocation = await location.getLocation();
      setState(() {
        mapPageState = MapPageState.map;
      });
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Location permission denied');
      }
      currentLocation = null;
    }
  }

  @override
  FloatingActionButton get fab => FloatingActionButton.extended(
        heroTag: "map",
        backgroundColor:
            ServiceProvider.instance.instanceStyleService.appStyle.green,
        foregroundColor: Colors.white,
        label: Text("Endre innstillinger"),
        icon: Icon(
          Icons.settings,
        ),
        onPressed: () => showCustomDialog(
          context: context,
          child: MapOptionsPage(
            controller: MapOptionsPageController(onUpdate: () => null),
          ),
        ),
      );

  @override
  String get title => mapPageState == MapPageState.noCurrentLocation
      ? "Posisjon ikke tilgjengelig"
      : null;

  @override
  Widget get bottomNav => null;

  @override
  Widget get actionOne => null;

  @override
  List<Widget> get actionTwoList => null;
}

class MapPage extends MasterPage {
  final MapPageController controller;

  MapPage({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.mapPageState == MapPageState.noCurrentLocation) {
      return Container(
        width: ServiceProvider.instance.screenService
            .getWidthByPercentage(context, 80),
        child: Column(children: <Widget>[
          Text(
              "Om du ønsker ta i bruk Min Hund's kartfunksjonalitet for å få en enklere hunde-hverdag vennligst del din posisjon med oss.",
              style:
                  ServiceProvider.instance.instanceStyleService.appStyle.body1),
          PrimaryButton(
            controller: PrimaryButtonController(
              text: "Del min posisjon",
              onPressed: () {
                controller.getLocation();
              },
            ),
          ),
        ]),
      );
    }
    if (controller.mapPageState == MapPageState.map)
      return Stack(
        children: <Widget>[
          GoogleMap(
            markers: controller.markers != null
                ? controller.markers
                : null,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                59.71949,
                10.83576,
              ),
              zoom: 14.4746,
            ),
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController localController) {
              controller.mapController.complete(localController);
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text("data"),
          ),
        ],
      );
    return Container();
  }
}
