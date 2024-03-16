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
        List<User>? users =
            jsonResponse.map((data) => User.fromJson(data)).toList();
        return users;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> registerUser(String userName, String firstName, String lastName, String mail, String pwrd, String pwrd2, DateTime ?birthDate) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(birthDate!);
    print(userApi);
    print('Date: $formattedDate');
    try {
      Dio dio = Dio();
      dio.options.baseUrl = userApi;
      //to parse a date:

      var response = await dio.post(
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
      // Handle response
      print('Request sent: post /user/register/');
      print(response.data);
      return true;
      // You can add further logic here based on the response
    } catch (e) {
      if (e is DioException) {
        print('DioError registering user: $e');
      } else {
        print('Error registering user: $e');
      }
      return false;
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
          "password": password,
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
}