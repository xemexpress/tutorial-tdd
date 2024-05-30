import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd/core/utils/typedef.dart';
import 'package:tdd/src/authentication/data/models/user_model.dart';
import 'package:tdd/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();

  test(
    'should be a subclass of [User] entity',
    () {
      // Arrange
      // Moved outside.

      // Act
      // No need to act here.

      // Assert
      expect(tModel, isA<User>());
    },
  );

  // Mocking the data from an external data source.
  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return a [UserModel] with the right data', () {
      // Arrange
      // Moved outside.

      // Act
      final result = UserModel.fromMap(tMap);

      // Assert
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {
    test('should return a [UserModel] with the right data', () {
      // Arrange
      // Moved outside.

      // Act
      final result = UserModel.fromJson(tJson);

      // Assert
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] with the right data', () {
      // Arrange
      // Moved outside.

      // Act
      final result = tModel.toMap();

      // Assert
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a [JSON] string with the right data', () {
      // Arrange
      // Moved outside.

      // Act
      final result = tModel.toJson();

      // Assert
      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('should return a [UserModel] with different data', () {
      // Arrange
      // Moved outside.

      // Act
      final result = tModel.copyWith(
        name: 'Bob',
      );

      // Assert
      expect(result.name, equals('Bob'));
      expect(result, isNot(tModel));
    });
  });
}
