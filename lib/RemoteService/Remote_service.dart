import 'package:ppf_mobile_client/Models/Users.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class RemoteService {
  Future<List<User>?> getUsers() async {
    try {
      Dio dio = Dio();
      dio.options.baseUrl = 'http://localhost:8081';
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
    print('Date: $formattedDate');
    try {
      Dio dio = Dio();
      dio.options.baseUrl = 'http://localhost:8081';
      //to parse a date:

      var response = await dio.post(
        '/users/register',
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
}