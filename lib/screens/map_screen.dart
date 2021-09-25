import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seaoil/models/list.dart';
import 'package:seaoil/models/location.dart';
import 'package:seaoil/providers/map_notifier.dart';
import 'package:seaoil/utils/constants.dart';
import 'package:seaoil/utils/sharedprefs.dart';
import 'package:seaoil/utils/tools.dart';
import 'package:provider/provider.dart';
import 'package:seaoil/widgets/bottom_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  final PanelController _pc = PanelController();
  static const CameraPosition _loc =
      CameraPosition(target: LatLng(14.582919, 120.979683), zoom: 15);
  final List<Marker> _markers = <Marker>[];
  final double _initFabHeight = 255.0;
  double _fabHeight = 0;
  double _panelHeightOpen = 500;
  double _panelHeightClosed = 250.0;
  var showDetails = false;
  ItemData? data;

  AnimationController? controllerAnim;
  AnimationController? controllerAnimDetails;

  @override
  void initState() {
    // TODO: implement initState
    controllerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    controllerAnimDetails = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fabHeight = _initFabHeight;
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    _determinePosition();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerAnim?.dispose();
    controllerAnimDetails?.dispose();
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
    Provider.of<MapNotifier>(context, listen: false).getLocationList(position);
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

  void setMarker(
      {required double lat,
      required double lng,
      required String location}) async {
    final markerIcon =
        await Tools().getBytesFromAsset("assets/station.png", 80);
    var marker = Marker(
        markerId: const MarkerId('station'),
        position: LatLng(lat, lng),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        infoWindow: InfoWindow(title: location));
    if (_markers.length != 1) {
      var index = _markers.indexWhere(
          (element) => element.markerId == const MarkerId('station'));
      _markers.removeAt(index);
      _markers.add(marker);
    } else {
      _markers.add(marker);
    }

    final controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 15)));
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

  Widget details() {
    var distance = data!.distance / 1000;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data!.data.name!,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        Text(
          data!.data.address!,
          style: const TextStyle(
              color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w400),
          maxLines: 2,
        ),
        const SizedBox(
          height: 14.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.directions_car_sharp,
                    size: 15.0, color: Colors.black),
                const SizedBox(
                  width: 4.0,
                ),
                Text(
                  '${distance.toStringAsFixed(2)} km away',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400),
                  maxLines: 2,
                ),
              ],
            ),
            const SizedBox(
              width: 6.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.access_time_outlined,
                    size: 15.0, color: Colors.black),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  'Open 24 Hours',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400),
                  maxLines: 2,
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _panel(ScrollController sc) {
    return Container(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: InkWell(
              onTap: () {
                if (showDetails) {
                  setState(() {
                    showDetails = false;
                    data = null;
                  });
                  controllerAnim?.reverse();
                  controllerAnimDetails?.reverse();
                }
              },
              child: Text(
                (showDetails) ? 'Back To List' : 'Nearby Station',
                style: TextStyle(
                    color: (showDetails) ? Colors.blue : Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
            ),
            trailing: TextButton(
              onPressed: () {
                if (showDetails) {}
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: (showDetails) ? Colors.blue : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Consumer<MapNotifier>(
            builder: (context, value, __) {
              if (value.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return (showDetails)
                  ? SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: controllerAnimDetails!,
                        curve: Curves.easeOut,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: details(),
                      ))
                  : Expanded(
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset.zero,
                          end: const Offset(-1.0, 0.0),
                        ).animate(CurvedAnimation(
                          parent: controllerAnim!,
                          curve: Curves.easeOut,
                        )),
                        child: ListView.builder(
                            padding: const EdgeInsets.only(right: 12.0),
                            controller: sc,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var totalDistance =
                                  value.data[index].distance / 1000;
                              return ListTile(
                                leading: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(value.data[index].data.name!,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                        '${totalDistance.toStringAsFixed(2)} km away from you',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                                trailing: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.grey,
                                  ),
                                  child: SizedBox(
                                    height: 25.0,
                                    width: 25.0,
                                    child: Radio(
                                      value: value.data[index].data,
                                      groupValue: value.rData,
                                      onChanged: (val) async {
                                        value
                                            .radioValue(value.data[index].data);
                                        setMarker(
                                            lat: double.parse(
                                                value.data[index].data.lat!),
                                            lng: double.parse(
                                                value.data[index].data.lng!),
                                            location:
                                                value.data[index].data.name!);
                                        setState(() {
                                          showDetails = true;
                                          data = value.data[index];
                                        });
                                        controllerAnim?.forward();
                                        controllerAnimDetails?.forward();
                                      },
                                      activeColor: const Color(0xff6c3eb5),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: value.data.length),
                      ),
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
            controller: _pc,
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
