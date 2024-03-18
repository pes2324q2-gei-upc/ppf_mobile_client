import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteCreationScreen extends StatefulWidget {
  const RouteCreationScreen({super.key});

  @override
  State<RouteCreationScreen> createState() => RouteCreationState();
}

class RouteCreationState extends State<RouteCreationScreen> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const CameraPosition _cameraPositionController = CameraPosition(
    target: LatLng(41.38668599929463, 2.196905132696342),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {};
  late List<LatLng> _polylineCoordinates = [];

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
    setState(() {
      _markers.add(
        const Marker(
          markerId: MarkerId('marker1'),
          position: LatLng(41.38668599929463, 2.196905132696342),
          infoWindow: InfoWindow(title: 'Marker 1'),
        ),
      );
      _markers.add(
        const Marker(
          markerId: MarkerId('marker2'),
          position: LatLng(42.37333679478278, 1.8870708333906143),
          infoWindow: InfoWindow(title: 'Marker 2'),
        ),
      );

      // Calculate and draw polyline between markers
      _polylineCoordinates = _calculateRoute(_markers.toList());
    });
  }

  List<LatLng> _calculateRoute(List<Marker> markers) {
    // Here you would normally use a routing service like Google Directions API
    // For simplicity, this example calculates a straight line between the markers
    List<LatLng> polylineCoordinates = [];
    for (int i = 0; i < markers.length - 1; i++) {
      polylineCoordinates.add(markers[i].position);
    }
    polylineCoordinates.add(markers.last.position);
    return polylineCoordinates;
  }

  String formatTime(int hour, int min) {
    // Create a TimeOfDay object
    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: min);

    // Format the time to a string in "hh:mm" format
    String formattedTime =
        '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  static const CameraPosition _kUPC = CameraPosition(
    bearing: 0.0,
    target: LatLng(41.38860749272642, 2.113867662148663),
    tilt: 45.0,
    zoom: 19.151926040649414,
  );

  void _goToUPC() async {
    final GoogleMapController controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kUPC));
  }

  void _joinRouteAction() {
    // Functionality for continuing action
    _goToUPC(); // Example functionality, you can replace this with your desired action
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey[500]),
      backgroundColor: Colors.grey[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        color: Colors.grey[500],
                        size: 20, // Reduced icon size
                      ),
                      const SizedBox(width: 4), // Reduced spacing
                      Container(
                        width: 150, // Reduced width for the container
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(8), // Reduced border radius
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding:
                                const EdgeInsets.all(4.0), // Reduced padding
                            child: Text(
                              'Place Holder',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12, // Reduced font size
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.more_vert,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4), // Reduced spacing
                      Container(
                        width: 191, // Reduced width for the container
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.circular(8), // Reduced border radius
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey[500],
                        size: 20, // Reduced icon size
                      ),
                      const SizedBox(width: 4), // Reduced spacing
                      Container(
                        width: 150, // Reduced width for the container
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(8), // Reduced border radius
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding:
                                const EdgeInsets.all(4.0), // Reduced padding
                            child: Text(
                              'Place Holder',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                                fontSize: 12, // Reduced font size
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.more_vert,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 4), // Reduced spacing
                      Container(
                        width: 191, // Reduced width for the container
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.circular(8), // Reduced border radius
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _cameraPositionController,
                markers: _markers,
                polylines: {
                  Polyline(
                    polylineId: const PolylineId('route'),
                    color: Colors.blue,
                    points: _polylineCoordinates,
                  ),
                },
                onMapCreated: _onMapCreated,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: _joinRouteAction,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green[500]!),
                ),
                child: const Text(
                  'Create route',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController contr, String? hint) {
    return TextField(
      controller: contr,
      autofocus: false,
      style: const TextStyle(fontSize: 12.0, height: 2.0),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 12.0,
            height: 2.0,
            color: Colors.grey[500],
            fontWeight: FontWeight.normal),
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(158, 158, 158, 1)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
