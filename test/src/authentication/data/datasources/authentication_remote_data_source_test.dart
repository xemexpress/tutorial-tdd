import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd/core/errors/exceptions.dart';
import 'package:tdd/core/utils/constants.dart';
import 'package:tdd/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd/src/authentication/data/models/user_model.dart';
import 'package:tdd/src/authentication/domain/entities/user.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImplementation(client);
    registerFallbackValue(Uri());
  });

  group('createUser', () {
    const newUser = UserModel.empty();

    test('should complete successfully when the status code is 200 or 201',
        () async {
      // Arrange

      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response('User created successfully', 201),
      );

      // Act
      final methodCall = remoteDataSource.createUser;
      // final resultFuture = remoteDataSource.createUser(
      //   createdAt: 'createdAt',
      //   name: 'name',
      //   avatar: 'avatar',
      // );

      // Assert
      expect(
        methodCall(
          createdAt: newUser.createdAt,
          name: newUser.name,
          avatar: newUser.avatar,
        ),
        // resultFuture,
        completes,
      );
      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          // Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
          body: jsonEncode(
            {
              'createdAt': newUser.createdAt,
              'name': newUser.name,
              'avatar': newUser.avatar,
            },
          ),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test(
        'should return [APIException]'
        'when the status code is not 200 or 201', () async {
      // Arrange
      final tResponse = http.Response('Invalid email address', 400);
      when(
        () => client.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => tResponse);

      // Act
      final methodCall = remoteDataSource.createUser;

      expect(
        () => methodCall(
          createdAt: newUser.createdAt,
          name: newUser.name,
          avatar: newUser.avatar,
        ),
        throwsA(
          APIException(
            message: tResponse.body,
            statusCode: tResponse.statusCode,
          ),
        ),
      );
      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          // Uri.parse('$kBaseUrl$kCreateUserEndpoint'),
          body: jsonEncode(
            {
              'createdAt': newUser.createdAt,
              'name': newUser.name,
              'avatar': newUser.avatar,
            },
          ),
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];

    test('should return [List<User>] when the status code is 200', () async {
      // Arrange
      when(
        () => client.get(any()),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode(
            tUsers.map((userModel) => userModel.toMap()).toList(),
          ),
          200,
        ),
      );

      // Act
      final result = await remoteDataSource.getUsers();
      // final methodCall = remoteDataSource.getUsers;

      // Assert
      expect(result, equals(tUsers));
      // expect(
      //   methodCall(),
      //   completion(isA<List<User>>()),
      // );
      verify(
        () => client.get(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          // Uri.parse('$kBaseUrl$kGetUsersEndpoint'),
        ),
      ).called(1);
      verifyNoMoreInteractions(client);
    });

    test('should throw [APIException] when the status code is not 200',
        () async {
      // Arrange
      final tResponse = http.Response('Server down. Mayday. Mayday', 500);

      when(
        () => client.get(any()),
      ).thenAnswer((_) async => tResponse);

      // Act
      final methodCall = remoteDataSource.getUsers;

      // Assert
      expect(
        methodCall,
        // () => methodCall(),
        throwsA(
          APIException(
            message: tResponse.body,
            statusCode: tResponse.statusCode,
          ),
        ),
      );
      verify(
        () => client.get(Uri.https(kBaseUrl, kGetUsersEndpoint)),
      ).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
