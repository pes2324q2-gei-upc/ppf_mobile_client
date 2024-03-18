import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  String selectedDepartureAddress = '';
  LatLng selectedDepartureLatLng = const LatLng(0.0,0.0);
  
  String selectedADestinationAddress = '';
  LatLng selectedDestinationLatLng = const LatLng(0.0,0.0);
  
  var uuid = const Uuid();

  List<dynamic> listForDepartures = [];
  List<dynamic> listForDestinations = [];

  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  
  void makeSuggestion(String input) async
  {
    var suggestions = await remoteService.makeSuggestionRemote(input, tokenForSession);
    setState(() {
      listForDepartures = suggestions;
    });
  }

  void onSuggestionSelected(String suggestion) {
    // Cierra la lista de sugerencias
    setState(() {
      listForDepartures = [];
    });
  }

void onModify() {
  // Verifica si el texto actual es igual al valor seleccionado anteriormente
  if (_departureController.text != selectedDepartureAddress) {
    // Si son diferentes, actualiza el valor seleccionado y haz una nueva solicitud de sugerencias
    selectedDepartureAddress = _departureController.text;
    if (tokenForSession == '') {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestion(selectedDepartureAddress);
  }
}

@override
  void initState() {
    super.initState();
    _departureController.addListener(() {
      onModify();
     });
     makeSuggestion(_departureController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Places Api Google Maps Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
    
            _buildTextField(_departureController, 'Salida'),
    
            _buildSuggestionList(_departureController),
            
            const SizedBox(height: 16.0),
            
            _buildTextField(_destinationController, 'Salida'),
    
            _buildSuggestionList(_destinationController),
          ],
        )
      ),
    );
  }

  Widget _buildSuggestionList(TextEditingController controller) {
    return Expanded(
      child: ListView.builder(
        itemCount: listForDepartures.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              selectedDepartureAddress = listForDepartures[index] ['description'];
              List<Location> locations = await locationFromAddress(listForDepartures[index] ['description']);
              selectedDepartureLatLng = LatLng(locations.last.latitude,locations.last.longitude);
              onSuggestionSelected(listForDepartures[index] ['description']);
              controller.text = listForDepartures[index] ['description'];
            },
            title: Text(listForDepartures[index]['description']),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController contr, String? hint) {
    return TextField(
      controller: contr,
      autofocus: false,
      style: const TextStyle(fontSize: 18.0),
      decoration: InputDecoration(
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
}