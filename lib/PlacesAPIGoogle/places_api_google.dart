import 'dart:async';
import 'dart:math';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ppf_mobile_client/views/testing_menu.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:ppf_mobile_client/RemoteService/Remote_service.dart';

class PlacesApiGoogleMaps extends StatefulWidget {
  const PlacesApiGoogleMaps({super.key});

  @override
  State<PlacesApiGoogleMaps> createState() => _PlacesApiGoogleMapsState();
}

class _PlacesApiGoogleMapsState extends State<PlacesApiGoogleMaps> {
  RemoteService remoteService = RemoteService();

  String tokenForSession = '';

  //final Set<Marker> _markers = {};

  String selectedDepartureAddress = '';
  LatLng selectedDepartureLatLng = const LatLng(0.0,0.0);
  
  String selectedDestinationAddress = '';
  LatLng selectedDestinationLatLng = const LatLng(0.0,0.0);
  
  var uuid = const Uuid();

  List<dynamic> listForDepartures = [];
  List<dynamic> listForDestinations = [];

  DateTime? _selectedDate;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _freeSpacesController = TextEditingController();
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  static const CameraPosition _cameraPositionController = CameraPosition(
    target: LatLng(41.38668599929463, 2.196905132696342),
    zoom: 14.4746,
  );

@override
  void initState() {
    super.initState();
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
              Row(
                children: [
                  const Column(
                    children: [
                      SizedBox(height: 16.0),
                      Icon(Icons.circle_outlined, size: 20),
                      SizedBox(width: 10),
                      Icon(Icons.more_vert, size: 30)
                    ],
                  ),
                  const SizedBox(width: 16),
                  Flexible(child:_buildTextField(_departureController, 'Salida', const Icon(Icons.search))),
                  const SizedBox(width: 16),
                ]
              ),
              _buildDepartureSuggestionList(),
              Row(
                children: [
                  const Column(
                    children: [
                      Icon(Icons.location_on_outlined, size: 30),
                      SizedBox(height: 16),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Flexible(child:_buildTextField(_destinationController, 'Destino', const Icon(Icons.search))),
                  const SizedBox(width: 16),
                ]
              ),
              _buildDestinationSuggestionList(),
              const SizedBox(height: 10.0), 
              Row(
                children: [
                  const SizedBox(width: 46),
                  Flexible(child:_buildNameSelector()),
                  const SizedBox(width: 16),
                ]
              ),
              const SizedBox(height: 16.0), 
              SizedBox(
                height: 400,
                child: _buildGoogleMap(),
              ),
              const SizedBox(height: 16.0),
              _buildCreateRouteButton(),
              const SizedBox(height: 16.0),
            ],
          )
        ),
      ),
    );
  }

  Widget _buildDepartureSuggestionList() {
    return Visibility(
      visible: _departureController.text.isNotEmpty && listForDepartures.isNotEmpty, 
      child: SizedBox(
        height: 300,
        child: Flexible(
          child: ListView.builder(
            itemCount: listForDepartures.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  setState(() {
                    selectedDepartureAddress = listForDepartures[index]['description'];
                    _departureController.text = selectedDepartureAddress;
                    listForDepartures = []; // Cerrar la lista de sugerencias
                  });
                  try {
                    List<Location> locations = await locationFromAddress(selectedDepartureAddress);
                    selectedDepartureLatLng = LatLng(locations.last.latitude, locations.last.longitude);
                  }
                  catch (e) {
                    _showError('Error: $e');
                  }
                },
                title: Text(listForDepartures[index]['description']),
              );
            },
          ),
        ),
      )
    );
  }

  Widget _buildDestinationSuggestionList() {
    return Visibility(
      visible: _destinationController.text.isNotEmpty && listForDestinations.isNotEmpty, 
      child: SizedBox(
        height: 300,
        child: Flexible(
          child: ListView.builder(
            itemCount: listForDestinations.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () async {
                  setState(() {
                    selectedDestinationAddress = listForDestinations[index]['description'];
                    _destinationController.text = selectedDestinationAddress;
                    listForDestinations = []; // Cerrar la lista de sugerencias
                  });
                  try {
                    List<Location> locations = await locationFromAddress(selectedDestinationAddress);
                    selectedDestinationLatLng = LatLng(locations.last.latitude, locations.last.longitude);
                  }
                  catch (e) {
                    _showError('Error: $e');
                  }
                },
                title: Text(listForDestinations[index]['description']),
              );
            },
          ),
        ),
      )
    );
  }

  Widget _buildTextField(TextEditingController contr, String? hint, Icon sufix) {
    return TextField(
      controller: contr,
      autofocus: false,
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

  Widget _buildGoogleMap() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _cameraPositionController,
          onMapCreated: _onMapCreated,
        ),
      ),
    );
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

  void _onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  Future<void> joinRouteAction () async {
    //Check for nulls
    String freeSpaces = _freeSpacesController.text; 
    String price = _priceController.text;
    if (selectedDepartureAddress.isEmpty || selectedDepartureLatLng.latitude == 0.0 || selectedDepartureLatLng.longitude == 0.0 || selectedDestinationAddress.isEmpty || selectedDestinationLatLng.latitude == 0.0 || selectedDestinationLatLng.longitude == 0.0 || _selectedDate == null || freeSpaces.isEmpty || price.isEmpty){
      _showError('$selectedDepartureAddress $selectedDestinationLatLng $selectedDestinationAddress $selectedDestinationLatLng $_selectedDate $freeSpaces $price');
    }
    else {
    var response = await remoteService.registerRoute(selectedDepartureAddress, selectedDepartureLatLng.latitude, selectedDepartureLatLng.longitude, selectedDestinationAddress, selectedDestinationLatLng.latitude, selectedDestinationLatLng.longitude, _selectedDate, freeSpaces, price);
              
      if (response == '') {
        Navigator.push(context,MaterialPageRoute(builder: (context) => const TestingMenu()));
      }

      else {
        _showError(response);
      }
    }
  }

  void makeDepartureSuggestion(String input) async
  {
    var suggestions = await remoteService.makeSuggestionRemote(input, tokenForSession);
    setState(() {
      listForDepartures = suggestions;
    });
  }

  void makeDestinationSuggestion(String input) async
  {
    var suggestions = await remoteService.makeSuggestionRemote(input, tokenForSession);
    setState(() {
      listForDestinations = suggestions;
    });
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
            borderSide: const BorderSide(color: Color.fromRGBO(158, 158, 158, 1)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _selectedDate == null
        ?RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(Icons.calendar_month, size:18),
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
                text: '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 18,  
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  _selectDate(BuildContext context) {
    if(_selectedDate != null){
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
            final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(_selectedDate!);
            print(selIOS);
          });
        },
      );
    }
    else{
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
            final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(_selectedDate!);
            print(selIOS);
          });
        },
      );
    }
  }

  Widget _buildNameSelector() {
    return Row(
      children: [

        Expanded(child: _buildDateSelector()),
        const SizedBox(width: 16),

        Expanded(child: _buildTextField(_priceController, 'Precio', const Icon(Icons.euro, size:16))),
        const SizedBox(width: 16),

        Expanded(child: _buildTextField(_freeSpacesController, 'Plazas libres', const Icon(Icons.person, size:18)))
      ],
    );
  }

  Future<void> _showError(String error)async {
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
}