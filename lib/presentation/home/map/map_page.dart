import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/service/service_provider.dart';
import '../../../bottom_navigation.dart';
import 'map-options/map_options_page.dart';

enum MapPageState { noCurrentLocation, map, options }

class MapPageController extends BottomNavigationController {
  static final MapPageController _instance = MapPageController._internal();

  factory MapPageController() {
    return _instance;
  }

  MapPageController._internal() {
    print("Map Page built");
  }

  Completer<GoogleMapController> mapController = Completer();

  LocationData currentLocation;

  Location location = new Location();

  MapPageState mapPageState = MapPageState.noCurrentLocation;

  @override
  void initState() {
    getLocation();
    super.initState();
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
  Widget get actionTwo => null;
}

class MapPage extends BottomNavigation {
  final MapPageController controller;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

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
