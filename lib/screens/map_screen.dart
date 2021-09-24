import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seaoil/models/location.dart';
import 'package:seaoil/providers/map_notifier.dart';
import 'package:seaoil/utils/constants.dart';
import 'package:seaoil/utils/sharedprefs.dart';
import 'package:seaoil/utils/tools.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  PanelController _pc = new PanelController();
  static const CameraPosition _loc =
      CameraPosition(target: LatLng(14.582919, 120.979683), zoom: 15);
  final List<Marker> _markers = <Marker>[];
  final double _initFabHeight = 110.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 500;
  double _panelHeightClosed = 100.0;
  List<Data> data = [];

  @override
  void initState() {
    // TODO: implement initState
    _fabHeight = _initFabHeight;
    super.initState();
    _determinePosition();
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // no need to use google my location feature since geolocator already gets the phones location
    _markers.clear();
    var position = await Geolocator.getCurrentPosition();
    final controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15)));

    final markerIcon =
        await Tools().getBytesFromAsset("assets/location.png", 80);
    var marker = Marker(
        markerId: const MarkerId('current_loc'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        infoWindow: const InfoWindow(title: 'You are here!'));
    _markers.add(marker);
    setState(() {});
  }

  void getUserLocation() async {
    _markers.clear();
    var position = await Geolocator.getCurrentPosition();
    final controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15)));
    final markerIcon =
        await Tools().getBytesFromAsset("assets/location.png", 80);
    var marker = Marker(
        markerId: const MarkerId('current_loc'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        infoWindow: const InfoWindow(title: 'You are here!'));
    _markers.add(marker);
    setState(() {});
  }

  Widget map() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _loc,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: Set<Marker>.of(_markers),
    );
  }

  Widget _panel(ScrollController sc) {
    return Container(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Text(
              'Nearby Station',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            trailing: TextButton(
              onPressed: () {},
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Consumer<MapNotifier>(
            builder: (context, value, __) {
              return Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    controller: sc,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text(value.data[index]!.name!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        trailing: Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.grey,
                          ),
                          child: SizedBox(
                            height: 25.0,
                            width: 25.0,
                            child: Radio(
                              value: index,
                              groupValue: value.rData,
                              onChanged: (val) {
                                value.radioValue(index);
                              },
                              activeColor: const Color(0xff6c3eb5),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: value.data.length),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Search Station"),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              SharedPrefUtils.deletePrefs(Constants.token_key);
            },
            icon: const Icon(Icons.search),
          )
        ],
        elevation: 5.0,
        bottom: PreferredSize(
            child: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints.expand(height: 25),
              child: const Text(
                "Which PriceLOCQ station will you likely visit?",
              ),
            ),
            preferredSize: const Size.fromHeight(25.0)),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            body: map(),
            panelBuilder: (sc) => _panel(sc),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),

          /// Created this FAB because the my location button of google maps goes on the upper right corner
          Positioned(
            right: 15.0,
            bottom: _fabHeight,
            child: FloatingActionButton(
              elevation: 2.5,
              child: const Icon(Icons.gps_fixed),
              onPressed: getUserLocation,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
