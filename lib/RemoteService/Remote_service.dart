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
    
      //Gestion de errores
    } on DioException catch (e) {
      Response? response = e.response;      
      
      //Error con codigo 400
      if(response?.statusCode == 400) {
        return null;
      }
      
      //Otros errores
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

      //Devuelve string vacia si no hay error
      if (response.statusCode == 200) {
        return '';
      }
      else {
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }
      
      //Gestion de errores
    } on DioException catch (e) {
      Response? response = e.response;      
      
      //Error con codigo 400
      if(response?.statusCode == 400) {
        return '$response';
      }
      
      //Otros errores
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
    
    //to parse a date:
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
          "dni": DNI,
          "capacity": int.parse(capacidad)
        },
      );

      //Devuelve string vacia si no hay error
      if (response.statusCode == 200) {
        return '';
      }
      else {
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }

      //Gestion de errores
    } on DioException catch (e) {
      Response? response = e.response;      
      
      //Error con codigo 400
      if(response?.statusCode == 400) {
        return '$response';
      }
      
      //Otros errores
      else{
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }
    }
  }

  Future<String> registerRoute(String routeName) async {
    //API call success
    try {
      Dio dio = Dio();
      dio.options.baseUrl = routeApi;
      Response response = await dio.post(
        '/routes/',
        data: {
          "routename": routeName
        }
      );

      //Devuelve string vacia si no hay error
      if (response.statusCode == 200) {
        return '';
      }
      else {
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }
      
      //Gestion de errores
    } on DioException catch (e) {
      Response? response = e.response;      
      
      //Error con codigo 400
      if(response?.statusCode == 400) {
        return '$response';
      }
      
      //Otros errores
      else{
        return 'Ha ocurrido un error inesperado. Porfavor, intentelo de nuevo más tarde';
      }
    }
  }
}