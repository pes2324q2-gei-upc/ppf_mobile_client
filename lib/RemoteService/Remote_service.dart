import 'dart:convert';

import 'package:ppf_mobile_client/Models/Users.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '/config.dart' show userApi;
import '/config.dart' show routeApi;

class RemoteService {
  Future<List<User>?> getUsers() async {
    print(userApi);
    try {
      Dio dio = Dio();
      dio.options.baseUrl = userApi;
      Response response = await dio.get('/users/');


      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = response.data;
        List<User>? users = jsonResponse.map((data) => User.fromJson(data)).toList();
        return users;
      } else {
        return null;
      }
    
      //Error handling
    } on DioException catch (e) {
      Response? response = e.response;      
      
      //Error code 400
      if(response?.statusCode == 400) {
        return null;
      }
      
      //Other errors
      else{
        return null;
      }
    }
  }

  Future<String> registerUser(
      String userName,
      String firstName,
      String lastName,
      String mail,
      String pwrd,
      String pwrd2,
      DateTime? birthDate) async {
    
    //Parse date:
    String formattedDate = DateFormat('yyyy-MM-dd').format(birthDate!);
    
    //API call success
    try {
      Dio dio = Dio();
      dio.options.baseUrl = userApi;
      
      //API call
      Response response = await dio.post(
        '/users/',
        data: {
          "username": userName,
          "first_name": firstName,
          "last_name": lastName,
          "email": mail,
          "birth_date": formattedDate, //formattedDate
          "password": pwrd,
          "password2": pwrd2
        },
      );

      //Return empty string if there was no error
      if (response.statusCode == 201) {
        return '';
      }
      else {
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }
      
      //Error handling
    } on DioException catch (e) {
      Response? response = e.response;      
      
      //Error code 400
      if(response?.statusCode == 400) {
        return '$response';
      }
      
      //Other errors
      else{
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }
    }
  }

  Future<String> registerDriver(
      String userName,
      String firstName,
      String lastName,
      String mail,
      String pwrd,
      String pwrd2,
      DateTime? birthDate,
      String DNI,
      String capacidad) async {
    
    //To parse a date:
    String formattedDate = DateFormat('yyyy-MM-dd').format(birthDate!);
    
    //API call success
    try {
      Dio dio = Dio();
      dio.options.baseUrl = userApi;

      print('accessing: $userApi/drivers/');

      Response response = await dio.post(
        '/drivers/',
        data: {
          "username": userName,
          "first_name": firstName,
          "last_name": lastName,
          "email": mail,
          "birth_date": formattedDate, //formattedDate
          "password": pwrd,
          "password2": pwrd2,
          "dni": DNI,
          "autonomy": int.parse(capacidad)
        },
      );

      //Return empty string if there was no error
      if (response.statusCode == 201) {
        return '';
      }
      else {
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }

      //Error handling
    } on DioException catch (e) {
      Response? response = e.response;      
      
      //Error code 400
      if(response?.statusCode == 400) {
        return '$response';
      }
      
      //Other errors
      else{
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }
    }
  }

  Future<String> registerRoute(String departure, double departureLatitude, double departureLongitude, String destination, double destinationLatitude, double destinationLongitude, DateTime? selectedDate, String freeSpaces, String price) async {
    //API call success
    try {
      Dio dio = Dio();
      dio.options.baseUrl = routeApi;
      Response response = await dio.post(
        '/routes/',
        data: {
          "preview": true,
          "route": {
            "originAlias": departure,
            "originLatitude": departureLatitude,
            "originLongitude": departureLongitude,
            "destinationAlias": destination, // ie Apenins 5, Badalona, España -> alias: Badalona
            "destinationLatitude": destinationLatitude,
            "destinationLongitude": destinationLongitude,
            "departureTime": selectedDate,
            "freeSeats": int.parse(freeSpaces),
            "price": double.parse(price)
          }
        }
      );

      //Return empty string if there was no error
      if (response.statusCode == 201) {
        return '';
      }
      else {
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }
      
      //Error handling
    } on DioException catch (e) {
      Response? response = e.response;      
      
      //Code 400 error
      if(response?.statusCode == 400) {
        return '$response';
      }
      
      //Other errors
      else{
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }
    }
  }

  Future<List<dynamic>> makeSuggestionRemote(String input, String tokenForSession) async
  {
    Dio dio = Dio();
    String googlePlacesApiKey = '';
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

      return jsonDecode(responseResult.toString()) ['predictions'];

    }
    on DioException catch (e) {
      List<dynamic> emptyList= [e];
      return emptyList;
    }
  }
}