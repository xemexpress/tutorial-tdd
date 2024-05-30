import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tdd/core/errors/exceptions.dart';
import 'package:tdd/core/utils/constants.dart';
import 'package:tdd/core/utils/typedef.dart';
import 'package:tdd/src/authentication/data/models/user_model.dart';

abstract class AuthenticationRemoteDataSource {
  // const AuthenticationRemoteDataSource();

  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = '/test-api/users';
const kGetUsersEndpoint = '/test-api/users';

class AuthenticationRemoteDataSourceImplementation
    implements AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // 1. check to make sure that it returns the right data
    // when the response code is 200 or the proper response code

    // 2. check to make sure that it throws the correct CUSTOM exception
    //   meaning a correct expected message and status code
    // when the response code is not 200 or the proper response code
    try {
      final response = await _client.post(
        Uri.https(kBaseUrl, kCreateUserEndpoint),
        body: jsonEncode(
          {
            'createdAt': createdAt,
            'name': name,
            'avatar': avatar,
          },
        ),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException.fromResponse(response);
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    // 1. Check if List<UserModel> is returned when the response code is 200
    // 2. Check if APIException is thrown when the response code is not 200
    // Future proof any dart errors

    try {
      final response = await _client.get(
        Uri.https(kBaseUrl, kGetUsersEndpoint),
        // Uri.parse('$kBaseUrl$kGetUsersEndpoint'),
      );

      if (response.statusCode != 200) {
        throw APIException.fromResponse(response);
      }

      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((e) => UserModel.fromMap(e))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}
