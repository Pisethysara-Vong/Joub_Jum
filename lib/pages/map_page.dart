import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:joub_jum/auth.dart';
import 'package:joub_jum/consts.dart';
import 'package:location/location.dart';
import 'package:joub_jum/pages/search_page.dart';
import 'package:joub_jum/pages/menu_bar_pages/account.dart';
import 'package:joub_jum/pages/menu_bar_pages/friend.dart';
import 'package:joub_jum/pages/menu_bar_pages/invitation.dart';
import 'package:joub_jum/pages/menu_bar_pages/joub_jum.dart';
import 'package:joub_jum/pages/menu_bar_pages/recommendation.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(11.5564, 104.9282);
  static const LatLng _testLocation = LatLng(11.50, 104.88);
  LatLng? _currentP;

  Map<PolylineId, Polyline> polylines = {};


  @override
  void initState() {
    //TODO setState for Polyline ONLY after they selected a location
    super.initState();
    getLocationUpdate().then((_) {
      _cameraToPosition(_currentP!).then((_) {
        getPolylinePoints().then((coordinate) {
          generatePolylineFromPoints(coordinate);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(),
      drawer: SizedBox(width: 250, height: 400, child: buildDrawer()),
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : Stack(
              children: [
                GoogleMap(
                  //when map is created, we have access to controller
                  onMapCreated: ((GoogleMapController controller) =>
                      _mapController.complete(controller)),
                  initialCameraPosition:
                      CameraPosition(target: _currentP!, zoom: 13),
                  markers: {
                    //Current location of user
                    Marker(
                        markerId: const MarkerId("_currentLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _currentP!),
                    const Marker(
                        markerId: MarkerId("_sourceLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _pGooglePlex),
                    const Marker(
                        markerId: MarkerId("_destinationLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _testLocation)
                  },
                  polylines: Set<Polyline>.of(polylines.values),
                ),
                buildCurrentLocationButton(),
              ],
            ),
    );
  }

  Positioned buildCurrentLocationButton() {
    return Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    _cameraToPosition(_currentP!);
                  },
                  child: const Icon(Icons.my_location),
                ),
              );
  }

  Drawer buildDrawer() {
    return Drawer(
      backgroundColor: menuBarColor,
      child: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          ListTile(
            title: const Text('Account'),
            onTap: () {
              navigateToNextScreen(context, const AccountPage());
            },
          ),
          ListTile(
            title: const Text('Recommendation'),
            onTap: () {
              navigateToNextScreen(context, const RecommendationPage());
            },
          ),
          ListTile(
            title: const Text('Invitation'),
            onTap: () {
              navigateToNextScreen(context, const InvitationPage());
            },
          ),
          ListTile(
            title: const Text('Joub Jum'),
            onTap: () {
              navigateToNextScreen(context, const JoubJumPage());
            },
          ),
          ListTile(
            title: const Text('Friend'),
            onTap: () {
              navigateToNextScreen(context, const FriendPage());
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () async {
              await AuthService().signout(context: context);
            },
          ),

        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appBarColor,
      elevation: 0,
      title: const Text(
        'Location',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      centerTitle: true,
      leading: Builder(builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            navigateToNextScreen(context, const SearchPage());
          },
        ),
      ],
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<void> getLocationUpdate() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    //Check if location services are enabled on user's device, otherwise request the user to enable them
    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    // Check if the app has location permission, If location permission is denied, request the user to grant permission
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  //TODO: Change point to _currentP and Selected Location
  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinate = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: GOOGLE_MAP_API_KEY,
        request: PolylineRequest(
            origin: PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
            destination:
                PointLatLng(_testLocation.latitude, _testLocation.longitude),
            mode: TravelMode.driving));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinate.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinate;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinate) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinate,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
