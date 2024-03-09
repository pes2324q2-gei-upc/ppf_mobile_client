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
}