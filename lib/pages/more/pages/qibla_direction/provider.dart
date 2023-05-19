import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../shared/widgets/easy_loading.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../shared/routes/routes_helper.dart';

class QiblaProvider extends ChangeNotifier {
  //for scrolling list of compass images

//for buttons changing color and display arrow insted of

  String _address = "";
  String get address => _address;
  double _lat = 0.0;
  double get lat => _lat;
  double _lng = 0.0;
  double get lng => _lng;
  int _qiblaDistance = 0;
  int get qiblaDistance => _qiblaDistance;

  Future getLocationPermission(BuildContext context) async {
    var isEnable = await Geolocator.isLocationServiceEnabled();
    if (isEnable) {
      Future.delayed(Duration.zero, () => getQiblaPageData(context));
    } else {
      await Permission.location.request().then((value) {
        if (value.isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please Enable Location Services')));
        } else if (value.isGranted) {
          Future.delayed(Duration.zero, () => getQiblaPageData(context));
        }
      });
    }
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // The user has not granted location permissions.
        // Show an error message or handle the error as appropriate.
      }
    }
  }

  Future<void> getQiblaPageData(BuildContext context) async {
    EasyLoadingDialog.show(context: context, radius: 20.r);
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 5));
      _lat = position.latitude;
      _lng = position.longitude;
      _qiblaDistance = calculateQiblaDistance(_lat, _lng).toInt();
      List<Placemark?> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placeMarks.isNotEmpty) {
        Placemark placeMark = placeMarks[0]!;
        String fullAddress = "${placeMark.locality}, ${placeMark.country}";
        _address = fullAddress;
        notifyListeners();
      }
      Future.delayed(Duration.zero, () {
        EasyLoadingDialog.dismiss(context);
        Navigator.of(context).pushNamed(
          RouteHelper.qiblaDirection,
        );
      });
    } on PlatformException catch (e) {
      EasyLoadingDialog.dismiss(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    } on TimeoutException {
      EasyLoadingDialog.dismiss(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('please restart your location services or check network')));
    } catch (e) {
      if (e.toString() ==
          "User denied permissions to access the device's location.") {
        openAppSettingsPermissionSection();
      }
      EasyLoadingDialog.dismiss(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Please Go to Settings and allow application to use Your Location')));
    }
  }

  Future<void> openAppSettingsPermissionSection() async {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'action_application_details_settings',
        data: 'package:com.example.nour_al_quran',
      );
      await intent.launch();
    }
  }

  double calculateQiblaDistance(double latitude, double longitude) {
    // Coordinates of the Kaaba in Mecca
    const double kaabaLatitude = 21.4225;
    const double kaabaLongitude = 39.8262;

    // Convert latitude and longitude to radians
    double lat1 = latitude * pi / 180.0;
    double lon1 = longitude * pi / 180.0;
    double lat2 = kaabaLatitude * pi / 180.0;
    double lon2 = kaabaLongitude * pi / 180.0;

    // Calculate the difference between the longitudes
    double dLon = lon2 - lon1;

    // Calculate the qibla direction (in radians)
    double qiblaDirection =
        atan2(sin(dLon), cos(lat1) * tan(lat2) - sin(lat1) * cos(dLon));

    // Convert qibla direction to degrees
    qiblaDirection = qiblaDirection * 180.0 / pi;

    // Calculate the distance to the qibla (in kilometers)
    double earthRadius = 6371.0; // Radius of the Earth in kilometers
    double distance =
        acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(dLon)) *
            earthRadius;

    return distance;
  }
}
