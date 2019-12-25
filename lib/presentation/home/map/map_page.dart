import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:location/location.dart';
import 'package:minhund/helper/helper.dart';
import 'package:minhund/model/map_options.dart';
import 'package:minhund/model/partner/partner.dart';
import 'package:minhund/model/place.dart';
import 'package:minhund/presentation/base_controller.dart';
import 'package:minhund/presentation/base_view.dart';
import 'package:minhund/presentation/widgets/buttons/primary_button.dart';
import 'package:minhund/presentation/widgets/buttons/secondary_button.dart';
import 'package:minhund/presentation/widgets/dialog/dialog_pop_button.dart';
import 'package:minhund/segments/partner_segment.dart';
import 'package:minhund/service/service_provider.dart';
import 'package:minhund/utilities/master_page.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'map-options/map_options_content.dart';

enum MapPageState { noCurrentLocation, map, options }

class MapPageController extends BaseController {
  static final MapPageController _instance = MapPageController._internal();

  factory MapPageController() {
    return _instance;
  }

  MapPageController._internal() {
    print("Map Page built");
  }

  Completer<GoogleMapController> mapController = Completer();

  LocationData currentLocation;

  Set<Marker> markers = {};

  Widget bottomSheet;

  Location location = new Location();

  bool hasLocation;

  MapOptions mapOptions = MapOptions(placeCategories: [
    PlaceCategory(
      colorIndex: 4,
      name: "Hundeparker",
      selected: true,
      markers: {},
    ),
    PlaceCategory(
      colorIndex: 1,
      name: "Dyrebutikker",
      selected: true,
      markers: {},
    )
  ]);

  MapPageState mapPageState = MapPageState.noCurrentLocation;

  @override
  void initState() {
    getPlaces();
    super.initState();
  }

  Future<void> getPlaces() async {
    QuerySnapshot qSnapPlaces =
        await Firestore.instance.collection("places").getDocuments();
    QuerySnapshot qSnapPartners = await Firestore.instance
        .collection("partners")
        .where("lat", isGreaterThan: 0)
        .getDocuments();

    for (DocumentSnapshot doc in qSnapPlaces.documents) {
      mapOptions.placeCategories[0].markers.add(Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(147),
          markerId: MarkerId(doc.documentID),
          position: LatLng(doc.data["lat"], doc.data["long"]),
          onTap: () async {
            Widget bp = await bottomTemplate(
                content: bottomPark(
                  Place.fromJson(doc.data),
                ),
                title: doc.data["name"],
                latLng: latlong.LatLng(doc.data["lat"], doc.data["long"]));

            revealBottomSheet(content: bp);
          }));
    }

    for (DocumentSnapshot doc in qSnapPartners.documents) {
      mapOptions.placeCategories[1].markers.add(Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(226),
          markerId: MarkerId(doc.documentID),
          position: LatLng(doc.data["lat"], doc.data["long"]),
          onTap: () async {
            Widget bp = await bottomTemplate(
                content: PartnerSegment(
                  withoutTitle: true,
                  partner: Partner.fromJson(doc.data),
                ),
                latLng: latlong.LatLng(doc.data["lat"], doc.data["long"]),
                title: doc.data["name"]);

            revealBottomSheet(content: bp);
          }));
    }

    markers.addAll(mapOptions.placeCategories[0].markers);
    markers.addAll(mapOptions.placeCategories[1].markers);

    setState(() {});
  }

  void revealBottomSheet({Widget content}) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return content;
      },
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(ServiceProvider
            .instance.instanceStyleService.appStyle.borderRadius),
        topRight: Radius.circular(ServiceProvider
            .instance.instanceStyleService.appStyle.borderRadius),
      )),
      elevation:
          ServiceProvider.instance.instanceStyleService.appStyle.elevation,
    );
  }

  onCategorySelect({PlaceCategory placeCategory}) {
    if (placeCategory.selected)
      markers.addAll(placeCategory.markers);
    else if (!placeCategory.selected) markers.removeAll(placeCategory.markers);

    setState(() {});
  }

  Future<Widget> bottomTemplate(
      {String title, Widget content, latlong.LatLng latLng}) async {
    LocationData locationData = await location.getLocation();

    double padding = getDefaultPadding(context);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PopButton(),
              Flexible(
                child: Text(
                  title ?? "",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.smallTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.close,
                color: Colors.transparent,
                size: ServiceProvider
                    .instance.instanceStyleService.appStyle.iconSizeStandard,
              ),
            ],
          ),
          Divider(
            thickness: 1,
          ),
          if (locationData != null && latLng != null) ...[
            Padding(
              padding: EdgeInsets.only(left: padding),
              child: Text(
                latlong.Distance()
                        .distance(
                            latlong.LatLng(
                                locationData.latitude, locationData.longitude),
                            latLng)
                        .round()
                        .toString() +
                    " km",
                style: ServiceProvider
                    .instance.instanceStyleService.appStyle.italic,
              ),
            ),
          ],
          Container(
            height: padding * 2,
          ),
          content,
        ],
      ),
    );
  }

  bottomPark(Place place) {
    return Padding(
      padding: EdgeInsets.all(getDefaultPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "En gjemt perle midt i smørøyet av lorem ipsum, is a dummy text that has been the industry standard since 1892",
            style: ServiceProvider.instance.instanceStyleService.appStyle.body1,
          ),
          if (place.lat != null && place.long != null) ...[
            SecondaryButton(
              text: "Veibeskrivelse",
              width: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 20),
              onPressed: () async {
                String googleUrl =
                    'https://www.google.com/maps/search/?api=1&query=${place.lat},${place.long}';
                if (await canLaunch(googleUrl)) {
                  await launch(googleUrl);
                } else {
                  throw 'Could not open the map.';
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget bottomPartner(Partner place) {
    return Padding(
      padding: EdgeInsets.all(getDefaultPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              PopButton(),
              Flexible(
                child: Text(
                  place.name,
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.smallTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.close,
                color: Colors.transparent,
                size: ServiceProvider
                    .instance.instanceStyleService.appStyle.iconSizeStandard,
              ),
            ],
          ),
          Container(
            height: getDefaultPadding(context) * 2,
          ),
          Text(
            "En gjemt perle midt i smørøyet av lorem ipsum, is a dummy text that has been the industry standard since 1892",
            style: ServiceProvider.instance.instanceStyleService.appStyle.body1,
          ),
          if (place.lat != null && place.long != null) ...[
            SecondaryButton(
              text: "Veibeskrivelse",
              width: ServiceProvider.instance.screenService
                  .getHeightByPercentage(context, 20),
              onPressed: () async {
                String googleUrl =
                    'https://www.google.com/maps/search/?api=1&query=${place.lat},${place.long}';
                if (await canLaunch(googleUrl)) {
                  await launch(googleUrl);
                } else {
                  throw 'Could not open the map.';
                }
              },
            ),
          ],
        ],
      ),
    );
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
      if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        await AppSettings.openLocationSettings().then((_) => print("done"));
        if (await location.hasPermission()) {
          currentLocation = await location.getLocation();
          setState(() {
            mapPageState = MapPageState.map;
          });
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed)
      Timer(Duration(milliseconds: 500), () => getLocation());
    super.didChangeAppLifecycleState(state);
  }
}

class MapPage extends BaseView {
  final MapPageController controller;

  MapPage({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    controller.currentLocation = Provider.of<LocationData>(context);

    if (controller.currentLocation != null)
      controller.mapPageState = MapPageState.map;

    if (controller.mapPageState == MapPageState.noCurrentLocation) {
      return Center(
        child: Container(
          width: ServiceProvider.instance.screenService
              .getWidthByPercentage(context, 80),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 20),
                ),
                Icon(
                  Icons.location_disabled,
                  size: ServiceProvider.instance.screenService
                      .getHeightByPercentage(context, 20),
                  color: ServiceProvider
                      .instance.instanceStyleService.appStyle.pink,
                ),
                Container(
                  height: getDefaultPadding(context) * 2,
                ),
                Text(
                  "Posisjon ikke tilgjengelig",
                  style: ServiceProvider
                      .instance.instanceStyleService.appStyle.title,
                ),
                Container(
                  height: getDefaultPadding(context) * 2,
                ),
                Text(
                    "Om du ønsker ta i bruk Min Hund's kartfunksjonalitet vennligst del din posisjon med oss.",
                    style: ServiceProvider
                        .instance.instanceStyleService.appStyle.body1),
                Container(
                  height: getDefaultPadding(context) * 2,
                ),
                PrimaryButton(
                  controller: PrimaryButtonController(
                    text: "Del min posisjon",
                    onPressed: () {
                      controller.getLocation();
                    },
                  ),
                ),
              ]),
        ),
      );
    }
    if (controller.mapPageState == MapPageState.map)
      return Stack(
        children: <Widget>[
          GoogleMap(
            markers: controller.markers != null ? controller.markers : null,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                59.71949,
                10.83576,
              ),
              zoom: 8.4746,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController localController) {
              if (!controller.mapController.isCompleted)
                controller.mapController.complete(localController);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Material(
                color: Color(0xFFFFFFF),
                shape: CircleBorder(),
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return MapOptionsContent(
                            mapOptions: controller.mapOptions,
                            onCheckboxAction: (cat) => controller
                                .onCategorySelect(placeCategory: cat));
                      },
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ServiceProvider.instance
                            .instanceStyleService.appStyle.borderRadius),
                        topRight: Radius.circular(ServiceProvider.instance
                            .instanceStyleService.appStyle.borderRadius),
                      )),
                      elevation: ServiceProvider
                          .instance.instanceStyleService.appStyle.elevation,
                    );
                  },
                  child: CircleAvatar(
                    radius: 30,
                    // foregroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.settings,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    return Container();
  }
}
