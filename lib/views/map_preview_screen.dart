import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(41.38668599929463, 2.196905132696342),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {};
  late List<LatLng> _polylineCoordinates = [];

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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

      // Adjust camera position to focus on markers
      _fitMarkersToBounds();
    });
  }

  List<LatLng> _calculateRoute(List<Marker> markers) {
    // Here you would normally use a routing service like Google Directions API
    // For simplicity, this example calculates a straight line between the markers
    List<LatLng> polylineCoordinates = [];
    for (int i = 0; i < markers.length; i++) {
      polylineCoordinates.add(markers[i].position);
    }
    return polylineCoordinates;
  }

  // ignore: unused_element
  LatLng _getRandomLatLng() {
    // Generate random latitude and longitude
    final double lat = 41.38860749272642 +
        (Random().nextDouble() - 0.5) * 0.5; // Adjust range as needed
    final double lng = 2.113867662148663 +
        (Random().nextDouble() - 0.5) * 0.5; // Adjust range as needed
    return LatLng(lat, lng);
  }

  String getOrigin() {
    return "Barcelona";
  }

  String getDestination() {
    return "Alp";
  }

  String getDistanceToDeparture() {
    double x = 2;
    return x.toString();
  }

  String getDistanceToDestination() {
    double x = 120;
    return x.toString();
  }

  String formatTime(int hour, int min) {
    // Create a TimeOfDay object
    TimeOfDay timeOfDay = TimeOfDay(hour: hour, minute: min);

    // Format the time to a string in "hh:mm" format
    String formattedTime =
        '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  String getDepartureTime() {
    int hour = 7;
    int min = 0;
    return formatTime(hour, min);
  }

  String getArrivalTime() {
    int hour = 14;
    int min = 30;
    return formatTime(hour, min);
  }

  String getFreeSeats() {
    int seats = 3;
    return seats.toString();
  }

  String getImport() {
    double import = 5.25;
    return import.toString();
  }

  static const CameraPosition _kUPC = CameraPosition(
    bearing: 0.0,
    target: LatLng(41.38860749272642, 2.113867662148663),
    tilt: 45.0,
    zoom: 19.151926040649414,
  );

  void _goToUPC() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kUPC));
  }

  void _joinRouteAction() {
    // Functionality for continuing action
    _goToUPC(); // Example functionality, you can replace this with your desired action
  }

  void _fitMarkersToBounds() {
    if (_markers.isEmpty) return;

    double minLat = _markers.first.position.latitude;
    double maxLat = _markers.first.position.latitude;
    double minLng = _markers.first.position.longitude;
    double maxLng = _markers.first.position.longitude;

    for (Marker marker in _markers) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;

      minLat = min(minLat, lat);
      maxLat = max(maxLat, lat);
      minLng = min(minLng, lng);
      maxLng = max(maxLng, lng);
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    const padding = 50.0; // Adjust padding as needed
    final cameraUpdate = CameraUpdate.newLatLngBounds(bounds, padding);

    _controller.future.then((controller) {
      controller.animateCamera(cameraUpdate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(8), // Reduced border radius
                ),
                child: Text(
                  '${getFreeSeats()} disponibles',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(), // To push the next element to the end
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(8), // Reduced border radius
                ),
                child: Text(
                  'importe total por pasajero ${getImport()}€', // Your text here
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Expanded(
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
                        padding: const EdgeInsets.all(4.0), // Reduced padding
                        child: Text(
                          getOrigin(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12, // Reduced font size
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    getDepartureTime(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding:
                                const EdgeInsets.all(1.0), // Reduced padding
                            child: Text(
                              "a ${getDistanceToDeparture()} km de tu punto de salida",
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
                              getDestination(),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.bold,
                                fontSize: 12, // Reduced font size
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        getArrivalTime(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding:
                                const EdgeInsets.all(1.0), // Reduced padding
                            child: Text(
                              "a ${getDistanceToDestination()} km de tu punto de llegada",
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
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
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
                  'Join Route',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Additional Content',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
