import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_application_7/datamodels/address.dart';
import 'package:flutter_application_7/dataprovider/appdata.dart';
import 'package:flutter_application_7/helper/request_helper.dart';
import 'package:flutter_application_7/widget/globalvariable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HelperMethod {
  // ignore: body_might_complete_normally_nullable
  static Future<String?> findCordinateAddress(
      Position position, context) async {
    String placeAdress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAdress;
    }
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey';

    // ignore: unused_local_variable
    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAdress = response['result'][0]['formatted_address'];

      Address pickupAddress = new Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAdress;

      Provider.of<appdata>(context, listen: false)
          .updatepickupAddress(pickupAddress);
    }
    return placeAdress;
  }
}
