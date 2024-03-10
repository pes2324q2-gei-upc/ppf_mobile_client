import 'package:ppf_mobile_client/Models/Users.dart';
import 'package:dio/dio.dart';

class RemoteService {
  Future<List<User>?> getUsers() async {
    try {
      var client = Dio();
      Response response = await client.get('http://127.0.0.1:8081/');

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
    RemoteService().getUsers();
    try {
      Dio dio = Dio();
      //to parse a date:
      Response response = await dio.post(
        '127.0.0.1:8081/create-user/',
        data: {
          {
            "username": userName,
            "first_name": firstName,
            "last_name": lastName,
            "email": mail,
            "birth_date": birthDate, //formattedDate
            "password": pwrd,
            "password2": pwrd2
          }
        },
      );
      // Handle response
      print(response.data);
      return true;
      // You can add further logic here based on the response
    } catch (e) {
      print('Error registering user: $e');
      return false;
      // Handle error
    }
  }
}