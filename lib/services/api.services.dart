import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getBaseUrl() {
  if (kIsWeb || Platform.isIOS || Platform.isMacOS) {
    return 'http://127.0.0.1:8000/api';
  } else if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000/api';
  } else {
    return '';
  }
}

Future<void> saveToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

final _dio = Dio(
  BaseOptions(
    baseUrl: getBaseUrl(),
    headers: {'Accept': 'application/json'},
  ),
);

Future<List> login(String email, String password) async {
  final response = await _dio.post('/auth/login', data: {
    'email': email,
    'password': password,
  });
  final String? token = response.data['access_token'];
  final int id = response.data['auth_user']['id'];
  final int user_type = response.data['auth_user']['user_type'];
  List data = [token, id, user_type];
  await saveToken(token!);
  return data;
}

Future<List<dynamic>> show(String token) async {
  final response = await _dio.get(
    '/auth/userinfo',
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  );
  List<dynamic> users = response.data;
  return users;
}

Future<dynamic> delete(int user_id, String token) async {
  final response = await _dio.delete(
    '/auth/userinfo/${user_id}',
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  );
  return response.data;
}

Future<Map<String, dynamic>> fetchuser_details(int userId) async {
  String? token = await getToken();
  final response = await _dio.get(
    '/auth/userinfo/${userId}',
    options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  );
  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Failed to load data from API');
  }
}

Future<String> createUser(
  String name,
  String email,
  String password,
  DateTime dateOfBirth,
  int userType,
  String image,
  int gender,
  String postCode,
  String address,
  String phoneNumber1,
  String phoneNumber2,
  String nationality,
  String district,
  String religion,
  String department,
  DateTime entryDate,
  DateTime? leavingDate,
  String education,
  String workExperiment,
  String hobby,
  String specialSkill,
  String language,
  String nrc
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? '';
  try {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final Map<String, dynamic> data = {
      "name": name,
      "email": email,
      "password": password,
      "date_of_birth": formatter.format(dateOfBirth),
      "user_type": userType,
      "image": {"mime": "image/jpg", "data": image},
      "gender": gender,
      "post_code": postCode,
      "address": address,
      "phone_number_1": phoneNumber1,
      "phone_number_2": phoneNumber2,
      "nationality": nationality,
      "district": district,
      "religion": religion,
      "department": department,
      "entry_date": formatter.format(entryDate),
      "education": education,
      "work_experience": workExperiment,
      "hobby": hobby,
      "special_skill": specialSkill,
      "language": language,
      "nrc": nrc
    };
    if (leavingDate != null) {
      data["leaving_date"] = formatter.format(leavingDate);
    }
    await _dio.post(
      '/auth/userinfo',
      data: data,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );
    return "OK";
  } catch (e) {
    String errorMessage = "Something went wrong";
    if (e is DioException) {
      if (e.response != null && e.response!.data != null) {
        try {
          var responseData = e.response!.data;
          if (responseData is String) {
            responseData = json.decode(responseData);
          }
          if (responseData is Map<String, dynamic>) {
            List<String> errors = [];
            responseData.forEach((key, value) {
              if (value is List) {
                errors.addAll(value.map((e) => e.toString()));
              } else if (value is String) {
                errors.add(value);
              }
            });
            errorMessage = errors.join(", ");
          } else {
            errorMessage = "An unexpected error format was received.";
          }
        } catch (e) {
          errorMessage = "An error occurred while parsing the error response.";
        }
      } else if (e.response != null) {
        errorMessage = e.response!.statusMessage ?? "An error occurred";
      }
    } else {
      errorMessage = "Unexpected error occurred: $e";
    }
    throw Exception(errorMessage);
  }
}

Future<Map<String, dynamic>> emailSending(String email,String name) async {
  String? token = await getToken();
  final response = await _dio.post('/auth/send-mail', data: {
    'email': email,
    'name': name
  },
  options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  );
  if (response.statusCode == 200) {
     print("response");
     print(response.data);
    return response.data;
  } else {
    throw Exception('Failed to load data from API');
  }
}

Future<String?> updatePassword(String email,String password,String password_confirmation) async {
   final response = await _dio.put('/auth/change-user-pass/$email?password=$password&password_confirmation=$password_confirmation');
    if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Failed to load data from API');
  }
}




