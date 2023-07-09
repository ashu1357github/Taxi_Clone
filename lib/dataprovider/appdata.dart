import 'package:flutter/foundation.dart';
import 'package:flutter_application_7/datamodels/address.dart';

class appdata extends ChangeNotifier {
  Address? pickupAddress;

  late Address destinationAddress;

  void updatepickupAddress(Address pickup) {
    pickupAddress = pickup;
    notifyListeners();
  }

  void updateDestinationAddress(Address destination) {
    destinationAddress = destination;
    notifyListeners();
  }
}
