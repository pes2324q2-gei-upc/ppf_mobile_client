import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
class PlacesApiGoogleMaps extends StatefulWidget {
  const PlacesApiGoogleMaps({super.key});

  @override
  State<PlacesApiGoogleMaps> createState() => _PlacesApiGoogleMapsState();
}

class _PlacesApiGoogleMapsState extends State<PlacesApiGoogleMaps> {
  
  String tokenForSession = '';

  String selectedAddress = '';
  String selectedLongitude = '';
  String selectedLatitude = '';

  var uuid = Uuid();

  List<dynamic> listForPlaces = [];

  final TextEditingController _controller = TextEditingController();
  
  void makeSuggestion(String input) async
  {
    Dio dio = Dio();
    String googlePlacesApiKey = 'AIzaSyDur4ZSjQ52es0R0tm-E2v35tQgsOIXGyw';
    String groundURL = 'https://maps.googleapis.com/maps/api/place/queryautocomplete/json';

    try {
      var responseResult = await dio.get
      (
        groundURL,
        queryParameters: 
        {
          'input': input,
          'key': googlePlacesApiKey,
          'sessiontoken': tokenForSession
        }
      );
      var resultData = responseResult.data;
      print('Result Data');
      print(resultData);

      if(responseResult.statusCode == 200) {
        setState(() {
          listForPlaces = jsonDecode(responseResult.toString()) ['predictions'];
        });
      }
    }
    on DioException catch (e) {
      print(e.message);
    }
  }

  void onSuggestionSelected(String suggestion) {
    // Cierra la lista de sugerencias
    setState(() {
      listForPlaces = [];
    });
    // Actualiza el valor del TextField con la sugerencia seleccionada
    _controller.text = suggestion;
  }

void onModify() {
  // Verifica si el texto actual es igual al valor seleccionado anteriormente
  if (_controller.text != selectedAddress) {
    // Si son diferentes, actualiza el valor seleccionado y haz una nueva solicitud de sugerencias
    selectedAddress = _controller.text;
    if (tokenForSession == '') {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestion(selectedAddress);
  }
}

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onModify();
     });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.teal],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Places Api Google Maps Search'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.orange],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ),
          ),  
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search here'
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listForPlaces.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        selectedAddress = listForPlaces[index] ['description'];

                        print('Selected address: $selectedAddress');

                        List<Location> locations = await locationFromAddress(listForPlaces[index] ['description']);

                        print(locations.last.longitude);
                        print(locations.last.latitude);

                        onSuggestionSelected(listForPlaces[index] ['description']);
                      },
                      title: Text(listForPlaces[index]['description']),
                    );
                  },
                ),
              )
            ],
          )
        ),
      )  
    );
  }
}