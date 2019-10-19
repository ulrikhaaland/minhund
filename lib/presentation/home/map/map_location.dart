import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/service/service_provider.dart';
import '../../../bottom_navigation.dart';

class MapLocationController extends BottomNavigationController {
  Completer<GoogleMapController> mapController = Completer();

  MapLocationController() {
    print("Map Page built");
  }

  LocationData currentLocation;

  var location = new Location();

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  Future<void> getLocation() async {
    try {
      currentLocation = await location.getLocation();
      setState(() {});
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Location permission denied');
      }
      currentLocation = null;
    }
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  @override
  FloatingActionButton get fab => currentLocation != null
      ? FloatingActionButton.extended(
          heroTag: "map",
          onPressed: _goToTheLake,
          label: Text('To the lake!'),
          icon: Icon(Icons.directions_boat),
        )
      : null;

  @override
  String get title =>
      currentLocation == null ? "Posisjon ikke tilgjengelig" : null;

  @override
  Widget get bottomNav => null;

  @override
  Widget get actionOne => null;

  @override
  Widget get actionTwo => null;
}

class MapLocation extends BottomNavigation {
  final MapLocationController controller;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  MapLocation({this.controller});

  @override
  Widget buildContent(BuildContext context) {
    if (!mounted) return Container();

    if (controller.currentLocation == null) {
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      // Color.fromARGB(255, 233, 242, 248), //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor: Colors.white,
      // Color.fromARGB(255, 233, 242, 248), //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ));
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.terrain,
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
  }
}
