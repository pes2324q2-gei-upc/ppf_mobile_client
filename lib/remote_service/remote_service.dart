// ignore: file_names
import 'package:ppf_mobile_client/Models/users.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '/config.dart' show userApi;
//import '/config.dart' show routeApi;

class RemoteService {
  Future<List<User>?> getUsers() async {
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
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> registerUser(String userName, String firstName, String lastName,
      String mail, String pwrd, String pwrd2, DateTime? birthDate) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(birthDate!);
    try {
      Dio dio = Dio();
      dio.options.baseUrl = userApi;
      //to parse a date:

      // ignore: unused_local_variable
      var response = await dio.post(
        '/users/',
        data: {
          "username": userName,
          "first_name": firstName,
          "last_name": lastName,
          "email": mail,
          "birth_date": formattedDate,
          "password": pwrd,
          "password2": pwrd2
        },
      );
      // Handle response
      return true;
      // You can add further logic here based on the response
    } catch (e) {
      if (e is DioException) {
      } else {}
      return false;
    }
  }
}
