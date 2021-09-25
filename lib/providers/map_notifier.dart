import 'package:flutter/material.dart';
import 'package:seaoil/models/list.dart';
import 'package:seaoil/models/location.dart';
import 'package:seaoil/services/api.dart';
import 'package:geolocator/geolocator.dart';

class MapNotifier extends ChangeNotifier {
  List<ItemData> data = [];
  Data rData = Data();
  var isLoading = false;

  void getLocationList(Position position) async {
    isLoading = true;
    notifyListeners();
    var result = await Api().getLocationList();
    if (result.data != null) {
      for (var i in result.data!) {
        double distanceInMeters = Geolocator.distanceBetween(position.latitude,
            position.longitude, double.parse(i.lat!), double.parse(i.lng!));

        data.add(ItemData(i, distanceInMeters));
      }
      data.sort((x, y) => x.distance.compareTo(y.distance));
      isLoading = false;
      notifyListeners();
    }
  }

  void radioValue(Data value) {
    rData = value;
    notifyListeners();
  }
}
