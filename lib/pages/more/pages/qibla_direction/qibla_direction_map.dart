import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nour_al_quran/pages/more/pages/qibla_direction/location_error_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nour_al_quran/pages/more/pages/qibla_direction/provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_colors/app_colors_provider.dart';
import 'package:nour_al_quran/pages/settings/pages/app_them/them_provider.dart';
import 'package:nour_al_quran/shared/localization/localization_constants.dart';
import 'package:nour_al_quran/shared/widgets/title_row.dart';
import 'package:provider/provider.dart';

class QiblahMaps extends StatefulWidget {
  static const makkahLatLong = LatLng(21.422487, 39.826206);
  final makkahMarker = Marker(
    markerId: const MarkerId("mecca"),
    position: makkahLatLong,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    draggable: false,
  );

  QiblahMaps({super.key});

  @override
  _QiblahMapsState createState() => _QiblahMapsState();
}

class _QiblahMapsState extends State<QiblahMaps> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng position = const LatLng(36.800636, 10.180358);

  Future<Position?>? _future;
  final _positionStream = StreamController<LatLng>.broadcast();

  @override
  void initState() {
    _future = _checkLocationStatus();
    super.initState();
  }

  @override
  void dispose() {
    _positionStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context: context, title: "Qibla Map"),
        body: Consumer3<QiblaProvider, AppColorsProvider, ThemProvider>(
            builder: (context, qibla, appColors, them, child) {
          return FutureBuilder(
            future: _future,
            builder: (_, AsyncSnapshot<Position?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                    margin: EdgeInsets.all(20.h),
                    child: CircularProgressIndicator(
                      color: them.isDark
                          ? Colors.white
                          : appColors.mainBrandingColor,
                    ));
              }
              if (snapshot.hasError) {
                return LocationErrorWidget(
                  error: snapshot.error.toString(),
                );
              }

              if (snapshot.data != null) {
                final loc =
                    LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
                position = loc;
              } else {
                _positionStream.sink.add(position);
              }

              return StreamBuilder(
                stream: _positionStream.stream,
                builder: (_, AsyncSnapshot<LatLng> snapshot) => GoogleMap(
                  mapType: MapType.satellite,
                  zoomGesturesEnabled: true,
                  compassEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  tiltGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: position,
                    zoom: 3,
                  ),
                  markers: <Marker>{
                    widget.makkahMarker,
                    Marker(
                      draggable: true,
                      markerId: const MarkerId('Marker'),
                      position: position,
                      icon: BitmapDescriptor.defaultMarker,
                      onTap: _updateCamera,
                      onDragEnd: (LatLng value) {
                        position = value;
                        _positionStream.sink.add(value);
                      },
                      zIndex: 5,
                    ),
                  },
                  circles: <Circle>{
                    Circle(
                      circleId: const CircleId("Circle"),
                      radius: 10,
                      center: position,
                      fillColor:
                          Theme.of(context).primaryColorLight.withAlpha(100),
                      strokeWidth: 1,
                      strokeColor:
                          Theme.of(context).primaryColorDark.withAlpha(100),
                      zIndex: 3,
                    )
                  },
                  polylines: <Polyline>{
                    Polyline(
                      polylineId: const PolylineId("Line"),
                      points: [position, QiblahMaps.makkahLatLong],
                      color: Colors.redAccent,
                      width: 5,
                      zIndex: 4,
                    )
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              );
            },
          );
        }));
  }

  Future<Position?> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled) {
      return await Geolocator.getCurrentPosition();
    }
    return null;
  }

  void _updateCamera() async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(position, 20));
  }
}
