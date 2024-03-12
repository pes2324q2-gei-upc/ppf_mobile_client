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

  Future<bool> registerUser(String userName, String firstName, String lastName, String mail, String pwrd, String pwrd2, DateTime? birthDate) async {
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

  Future<bool> registerDriver(String userName, String firstName, String lastName, String mail, String pwrd, String pwrd2, DateTime? birthDate, String DNI, String capacidad) async {
    //to parse a date:
    String formattedDate = DateFormat('yyyy-MM-dd').format(birthDate!);
    print(userApi);
    print('Date: $formattedDate');
    try {
      Dio dio = Dio();
      dio.options.baseUrl = userApi;
      var response = await dio.post(
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
      // Handle response
      print('Request sent: post /user/');
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
  bool registerRoute(String routeName) {
    try {
      Dio dio = Dio();
      dio.options.baseUrl = routeApi;
      var response = dio.post(
        '/routes/',
        data:{
          "routename": routeName
        }
      );
      print('$response');
      return true;
    }
    catch(e) {
      if (e is DioException) {
        print('DioError registering toute: $e');
      }
      else {
        print('Error registering user: $e');
      }
      return false;
    }
    
  }
}