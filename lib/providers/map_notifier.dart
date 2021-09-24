import 'package:flutter/material.dart';
import 'package:seaoil/models/location.dart';
import 'package:seaoil/services/api.dart';

class MapNotifier extends ChangeNotifier {
  List<Data?> data = [];
  int rData = 0;

  MapNotifier() {
    getLocationList();
  }

  void getLocationList() async {
    var result = await Api().getLocationList();
    if (result.data != null) {
      data.addAll(result.data!);
      notifyListeners();
    }
  }

  void radioValue(int value) {
    rData = value;
    notifyListeners();
  }
}
