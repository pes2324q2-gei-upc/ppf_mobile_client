import 'dart:convert';
import 'package:ppf_mobile_client/Models/Users.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:ppf_mobile_client/models/Route.dart';
import '/config.dart' show GOOGLE_MAPS_API_KEY, userApi;
import '/config.dart' show routeApi;

class RemoteService {
  Future<List<User>?> getUsers() async {
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
      String dni,
      String capacidad) async {
    
    //To parse a date:
    String formattedDate = DateFormat('yyyy-MM-dd').format(birthDate!);
    
    //API call success
    try {
      Dio dio = Dio();
      dio.options.baseUrl = userApi;
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
          "dni": dni,
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
    

    String formattedDate = DateFormat('yyyy-MM-ddThh:mm:ss').format(selectedDate!);
    
    //API call success
    try {
      Dio dio = Dio();
      dio.options.baseUrl = routeApi;
      Response response = await dio.post(
        '/routes/',
        data: {
          "originAlias": departure,
          "originLat": departureLatitude,
          "originLon": departureLongitude,
          "destinationAlias": destination,
          "destinationLat": destinationLatitude,
          "destinationLon": destinationLongitude,
          "departureTime": formattedDate,
          "freeSeats": int.parse(freeSpaces),
          "price": double.parse(price)
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
      
      //Error code 400
      if(response?.statusCode == 404) {
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
    String googlePlacesApiKey = GOOGLE_MAPS_API_KEY;
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

      return jsonDecode(responseResult.toString()) ['predictions'];

    }
    on DioException catch (e) {
      List<dynamic> emptyList= [e];
      return emptyList;
    }
  }

  Future<String> logInUser(String email, String password) async {
    try {
      Dio dio = Dio();
      dio.options.baseUrl = userApi;
      Response response = await dio.post(
        '/login/',
        data: {
          "email": email,
          "password": password
        }
      );
      if (response.statusCode == 200) {
        dynamic jsonResponse = response.data;
        return jsonResponse["token"] as String;
      } 
      return "";
    } on DioException catch (e) {
      Response? response = e.response;

      //Code 400 error
      if(response?.statusCode == 401) {
        return "Invalid credentials";
      }

      //Other errors
      else{
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }
    }
  }
  Future<MapRoute> getMapRoute(int routeId) async {
    try {
      var id = routeId.toString();
      Dio dio = Dio();
      dio.options.baseUrl = routeApi;
      var response = await dio.get('/routes/$id');

      // Check if response is successful
      if (response.statusCode == 200) {
        // Parse JSON response
        var json = response.data;

        // Create MapRoute object from JSON using factory method
        MapRoute mapRoute =
            MapRoute.fromJson(json); //MapRoute.fromJson(responseData);

        // Return the created MapRoute object
        return mapRoute;
      } else {
        // Handle unsuccessful response
        throw Exception('Failed to load route');
      }
    } on DioException catch (e) {
      // Handle Dio errors
      print(e.error);
      throw Exception('Failed to load route');
    }
  }
}
