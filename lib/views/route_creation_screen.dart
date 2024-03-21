import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ppf_mobile_client/config.dart';
import 'package:ppf_mobile_client/views/testing_menu.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:ppf_mobile_client/RemoteService/Remote_service.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RouteCreationScreen extends StatefulWidget {
  const RouteCreationScreen({super.key});

  @override
  State<RouteCreationScreen> createState() => _RouteCreationScreenState();
}

class _RouteCreationScreenState extends State<RouteCreationScreen> {
  RemoteService remoteService = RemoteService();

  String tokenForSession = '';
  LatLng currentUserPosition = const LatLng(0.0, 0.0);

  Map<PolylineId, Polyline> polylines = {};

  String selectedDepartureAddress = '';
  LatLng selectedDepartureLatLng = const LatLng(0.0, 0.0);

  String selectedDestinationAddress = '';
  LatLng selectedDestinationLatLng = const LatLng(0.0, 0.0);

  var uuid = const Uuid();

  List<dynamic> listForDepartures = [];
  List<dynamic> listForDestinations = [];

  DateTime? _selectedDate;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _freeSpacesController = TextEditingController();
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _liveLocation();
    getCurrentLatLng();
    _departureController.addListener(() {
      onModifyDeparture();
    });
    _destinationController.addListener(() {
      onModifyDestination();
    });
    makeDepartureSuggestion(_departureController.text);
    makeDestinationSuggestion(_destinationController.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _closeSuggestionLists();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[300],
        appBar: AppBar(),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                Row(children: [
                  const Column(
                    children: [
                      SizedBox(height: 16.0),
                      Icon(Icons.circle_outlined, size: 20),
                      SizedBox(width: 10),
                      Icon(Icons.more_vert, size: 30)
                    ],
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                      child: _buildTextField(_departureController, 'Salida',
                          const Icon(Icons.search))),
                  const SizedBox(width: 16),
                ]),
                _buildDepartureSuggestionList(),
                Row(children: [
                  const Column(
                    children: [
                      Icon(Icons.location_on_outlined, size: 30),
                      SizedBox(height: 16),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                      child: _buildTextField(_destinationController, 'Destino',
                          const Icon(Icons.search))),
                  const SizedBox(width: 16),
                ]),
                _buildDestinationSuggestionList(),
                const SizedBox(height: 10.0),
                Row(children: [
                  const SizedBox(width: 46),
                  Flexible(child: _buildFieldSelectors()),
                  const SizedBox(width: 16),
                ]),
                const SizedBox(height: 16.0),
                _buildMap(),
                const SizedBox(height: 16.0),
                _buildCreateRouteButton(),
                const SizedBox(height: 16.0),
              ],
            )),
      ),
    );
  }

  Widget _buildMap() {
    return SizedBox(
      height: 400,
      child: (currentUserPosition.latitude == 0 &&
              currentUserPosition.longitude == 0)
          ? const Center(child: Text("Loading..."))
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: currentUserPosition, zoom: 14),
              markers: {
                Marker(
                    markerId: MarkerId('currentPosition'),
                    position: currentUserPosition,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue)),
                Marker(
                  markerId: const MarkerId('departure'),
                  position: selectedDepartureLatLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
                Marker(
                  markerId: const MarkerId('destination'),
                  position: selectedDestinationLatLng,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              },
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
            ),
    );
  }

  Widget _buildDepartureSuggestionList() {
    return Visibility(
        visible: _departureController.text.isNotEmpty &&
            listForDepartures.isNotEmpty,
        child: SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: listForDepartures.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  setState(() {
                    selectedDepartureAddress =
                        listForDepartures[index]['description'];
                    _departureController.text = selectedDepartureAddress;
                    listForDepartures = []; // Cerrar la lista de sugerencias
                  });
                  try {
                    List<Location> locations =
                        await locationFromAddress(selectedDepartureAddress);
                    selectedDepartureLatLng = LatLng(
                        locations.last.latitude, locations.last.longitude);
                    suggestionSelected();
                  } catch (e) {
                    _showError('Error: $e');
                  }
                },
                title: Text(listForDepartures[index]['description']),
              );
            },
          ),
        ));
  }

  Widget _buildDestinationSuggestionList() {
    return Visibility(
        visible: _destinationController.text.isNotEmpty &&
            listForDestinations.isNotEmpty,
        child: SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: listForDestinations.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  setState(() {
                    selectedDestinationAddress =
                        listForDestinations[index]['description'];
                    _destinationController.text = selectedDestinationAddress;
                    listForDestinations = []; // Cerrar la lista de sugerencias
                  });
                  try {
                    List<Location> locations =
                        await locationFromAddress(selectedDestinationAddress);
                    selectedDestinationLatLng = LatLng(
                        locations.last.latitude, locations.last.longitude);
                    suggestionSelected();
                  } catch (e) {
                    _showError('Error: $e');
                  }
                },
                title: Text(listForDestinations[index]['description']),
              );
            },
          ),
        ));
  }

  Widget _buildTextField(
      TextEditingController contr, String? hint, Icon sufix) {
    return TextField(
      controller: contr,
      autofocus: false,
      style: const TextStyle(fontSize: 18.0),
      onTap: () {
        setState(() {
          listForDepartures = [];
          listForDestinations = []; 
        });
      },
      decoration: InputDecoration(
        suffixIcon: sufix,
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 18.0,
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

  Widget _buildNumberField(
      TextEditingController contr, String? hint, Icon sufix, bool isDouble) {
    return TextField(
      controller: contr,
      autofocus: false,
      keyboardType: TextInputType.number,
      onTap: () {
        setState(() {
          listForDepartures = [];
          listForDestinations = []; 
        });
      },
      inputFormatters: isDouble
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9 .]'))
            ]
          : <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(fontSize: 18.0),
      decoration: InputDecoration(
        suffixIcon: sufix,
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 18.0,
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

  Future<void> _cameraToPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 14)));
  }

  Widget _buildCreateRouteButton() {
    return Center(
      child: SizedBox(
        width: 300,
        child: ElevatedButton(
          onPressed: joinRouteAction,
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
    );
  }

  void _fitRouteBounds(List<LatLng> coordinates) {
    double minLat = coordinates[0].latitude;
    double maxLat = coordinates[0].latitude;
    double minLong = coordinates[0].longitude;
    double maxLong = coordinates[0].longitude;

    for (LatLng coord in coordinates) {
      if (coord.latitude > maxLat) maxLat = coord.latitude;
      if (coord.latitude < minLat) minLat = coord.latitude;
      if (coord.longitude > maxLong) maxLong = coord.longitude;
      if (coord.longitude < minLong) minLong = coord.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLong),
      northeast: LatLng(maxLat, maxLong),
    );

    _mapController.future.then((controller) {
      controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    });
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        currentUserPosition = positionToLatLng(position);
        _cameraToPosition(currentUserPosition);
      });
    });
  }

  Future<void> getCurrentLatLng() async {
    Position position = await getCurrentLocation();
    currentUserPosition = positionToLatLng(position);
    return;
  }

  LatLng positionToLatLng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('Location permissions are denied');
      }
      if (permission == LocationPermission.deniedForever) {
        _showError(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  Future<void> joinRouteAction() async {
    //Check for nulls
    String freeSpaces = _freeSpacesController.text;
    String price = _priceController.text;
    if (selectedDepartureAddress.isEmpty ||
        selectedDepartureLatLng.latitude == 0.0 ||
        selectedDepartureLatLng.longitude == 0.0 ||
        selectedDestinationAddress.isEmpty ||
        selectedDestinationLatLng.latitude == 0.0 ||
        selectedDestinationLatLng.longitude == 0.0 ||
        _selectedDate == null ||
        freeSpaces.isEmpty ||
        price.isEmpty) {
      _showError('Porfavor, rellene todos los campos');
    } else {
      print('hola1');
      var response = await remoteService.registerRoute(
          selectedDepartureAddress,
          selectedDepartureLatLng.latitude,
          selectedDepartureLatLng.longitude,
          selectedDestinationAddress,
          selectedDestinationLatLng.latitude,
          selectedDestinationLatLng.longitude,
          _selectedDate,
          freeSpaces,
          price);

      if (response == '') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TestingMenu()));
      } else {
        _showError('Error al crear la ruta, porfavor, intentelo de nuevo mas tarde');
      }
    }
  }

  void makeDepartureSuggestion(String input) async {
    var suggestions =
        await remoteService.makeSuggestionRemote(input, tokenForSession);
    setState(() {
      listForDepartures = suggestions;
    });
  }

  void makeDestinationSuggestion(String input) async {
    var suggestions =
        await remoteService.makeSuggestionRemote(input, tokenForSession);
    setState(() {
      listForDestinations = suggestions;
    });
  }

  void suggestionSelected() {
    //Both suggestions selected
    setState(() {});
    if (selectedDepartureLatLng.latitude != 0 &&
        selectedDepartureLatLng.latitude != 0 &&
        selectedDestinationLatLng.latitude != 0 &&
        selectedDestinationLatLng.longitude != 0) {
      getPolylinePoints().then((coordinates) => {
            generatePolyLineFromPoints(coordinates),
            _fitRouteBounds(coordinates),
          });
    }
    //Only one suggestion selected
    else if ((selectedDepartureLatLng.latitude != 0 &&
            selectedDepartureLatLng.latitude != 0) ||
        (selectedDestinationLatLng.latitude != 0 &&
            selectedDestinationLatLng.longitude != 0)) {
      //Selected departure
      if (selectedDepartureLatLng.latitude != 0 &&
          selectedDepartureLatLng.latitude != 0) {
        _cameraToPosition(selectedDepartureLatLng);
      }
      //Selected destination
      else if (selectedDestinationLatLng.latitude != 0 &&
          selectedDestinationLatLng.longitude != 0) {
        _cameraToPosition(selectedDestinationLatLng);
      }
    }
  }

  void onSuggestionDepartureSelected(String suggestion) {
    // Cierra la lista de sugerencias
    setState(() {
      listForDepartures = [];
    });
  }

  void onSuggestionDestinationSelected(String suggestion) {
    // Cierra la lista de sugerencias
    setState(() {
      listForDestinations = [];
    });
  }

  void onModifyDeparture() {
    // Verifica si el texto actual es igual al valor seleccionado anteriormente
    if (_departureController.text != selectedDepartureAddress) {
      // Si son diferentes, actualiza el valor seleccionado y haz una nueva solicitud de sugerencias
      setState(() {
        selectedDepartureAddress = _departureController.text;
      });
      if (tokenForSession == '') {
        setState(() {
          tokenForSession = uuid.v4();
        });
      }
      makeDepartureSuggestion(selectedDepartureAddress);
    }
  }

  void onModifyDestination() {
    // Verifica si el texto actual es igual al valor seleccionado anteriormente
    if (_destinationController.text != selectedDestinationAddress) {
      // Si son diferentes, actualiza el valor seleccionado y haz una nueva solicitud de sugerencias
      setState(() {
        selectedDestinationAddress = _destinationController.text;
      });
      if (tokenForSession == '') {
        setState(() {
          tokenForSession = uuid.v4();
        });
      }
      makeDestinationSuggestion(selectedDestinationAddress);
    }
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromRGBO(158, 158, 158, 1)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _selectedDate == null
              ? RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(Icons.calendar_month, size: 18),
                      ),
                      TextSpan(
                        text: 'Salida',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(Icons.calendar_month, size: 18),
                      ),
                      TextSpan(
                        text:
                            '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  _selectDate(BuildContext context) {
    setState(() {
      listForDepartures = [];
      listForDestinations = []; 
    });
    if (_selectedDate != null) {
      return DatePicker.showDatePicker(
        context,
        dateFormat: 'dd MMMM yyyy HH:mm',
        initialDateTime: _selectedDate!,
        minDateTime: DateTime.now(),
        maxDateTime: DateTime(3000),
        onMonthChangeStartWithFirstDate: true,
        onConfirm: (dateTime, List<int> index) {
          setState(() {
            _selectedDate = dateTime;
            final selIOS =
                DateFormat('dd-MMM-yyyy - HH:mm').format(_selectedDate!);
            print(selIOS);
          });
        },
      );
    } else {
      return DatePicker.showDatePicker(
        context,
        dateFormat: 'dd MMMM yyyy HH:mm',
        initialDateTime: DateTime.now(),
        minDateTime: DateTime.now(),
        maxDateTime: DateTime(3000),
        onMonthChangeStartWithFirstDate: true,
        onConfirm: (dateTime, List<int> index) {
          setState(() {
            _selectedDate = dateTime;
            final selIOS =
                DateFormat('dd-MMM-yyyy - HH:mm').format(_selectedDate!);
            print(selIOS);
          });
        },
      );
    }
  }

  Widget _buildFieldSelectors() {
    return Row(
      children: [
        Expanded(child: _buildDateSelector()),
        const SizedBox(width: 16),
        Expanded(
            child: _buildNumberField(_priceController, 'Precio',
                const Icon(Icons.euro, size: 16), true)),
        const SizedBox(width: 16),
        Expanded(
            child: _buildNumberField(_freeSpacesController, 'Plazas libres',
                const Icon(Icons.person, size: 18), false))
      ],
    );
  }

  Future<void> _showError(String error) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _closeSuggestionLists() {
    setState(() {
      listForDepartures = [];
      listForDestinations = [];
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_MAPS_API_KEY,
        PointLatLng(selectedDepartureLatLng.latitude,
            selectedDepartureLatLng.longitude),
        PointLatLng(selectedDestinationLatLng.latitude,
            selectedDestinationLatLng.longitude),
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        _showError(
            'No se ha podido encontrar una ruta entre los puntos seleccionados');
      }
    } catch (e) {
      _showError('Error: $e');
    }

    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }
}