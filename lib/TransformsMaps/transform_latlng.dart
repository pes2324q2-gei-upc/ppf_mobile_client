import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class TransformLatLngToAddress extends StatefulWidget {
  const TransformLatLngToAddress({super.key});

  @override
  State<TransformLatLngToAddress> createState() => _TransformLatLngToAddressState();
}

class _TransformLatLngToAddressState extends State<TransformLatLngToAddress> {
  
  String placeM = '';
  String addressOnScreen = '';
  
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(addressOnScreen),
            Text(placeM),
            GestureDetector(
              onTap: () 
              async 
              {
                List<Location> location = await locationFromAddress('Spain, Barcelona');

                List<Placemark> placemark = await placemarkFromCoordinates(41.38828011823373, 2.112438166663977);  
                setState(() {
                  placeM = '${placemark.reversed.last.country} ${placemark.reversed.last.locality}';
                  addressOnScreen = '${location.last.longitude} ${location.last.latitude}';
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40, 
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                  ),
                  child: const Center(
                    child: Text('Hit to convert'),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}