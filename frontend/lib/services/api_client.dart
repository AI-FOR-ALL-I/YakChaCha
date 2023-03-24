import 'package:dio/dio.dart';
import 'api_constants.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseurl,
  ),
);

class ApiClient {
  static Future<Response> login(
      String type, String email, String password) async {
    final data = {
      'type': type,
      'id': email,
      'password': password,
    };
    return dio.post(ApiConstants.login,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}));
  }

  static Future<Response> logout(String accessToken) async {
    // accessToken은 따로 getX? storage에 저장할거니까 일단은 임의로 String 넣어놓음

    return dio.put(ApiConstants.logout,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorzation': 'Bearer $accessToken'
        }));
  }

  // 호출방법은 아래와 같은 방법인듯.
  /*
  Future<void> fetchUsers() async {
  try {
    Response response = await ApiClient.getUsers();
    // handle response data
  } catch (e) {
    // handle error
  }
}
Future<void> fetchUsers() async {
  try {
    Response response = await ApiClient.getUsers();

    List<dynamic> users = response.data;
    
    // handle users data
  } catch (e) {
    // handle error
  }
} 
Future<void> loginUser(String email, String password) async {
  try {
    Response response = await ApiClient.login(email, password);

    // handle response data
  } catch (e) {
    // handle error
  }
}

Future<void> registerUser(String name, String email, String password) async {
  try {
    Response response = await ApiClient.register(name, email, password);

    // handle response data
  } catch (e) {
    // handle error
  }
}
  */
}
