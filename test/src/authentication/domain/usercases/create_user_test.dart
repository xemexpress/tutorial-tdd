//  Three questions to answer when writing tests:
// 1. What does the class depend on?
// AuthenticationRepository

// 2. What can we use to create a fake version of the dependency?
// Mocktail

// 3. How do we control what our dependencies do?
// Using the Mocktail's APIs

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd/src/authentication/domain/usercases/create_user.dart';

import 'authentication_repository.mock.dart';

void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = CreateUser(repository);

    // registerFallbackValue(Football());
  });

  const params = CreateUserParams.empty();

  // const params = CreateUserParams(
  //   createdAt: 'createdAt',
  //   name: 'name',
  //   avatar: 'avatar',
  // );

  test(
    'should call the [AuthenticationRepository.createUser]',
    () async {
      // Arrange
      when(
        () => repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
          // createdAt: any(),
          // name: any(),
          // avatar: any(),
        ),
      ).thenAnswer((_) async => const Right(null));
      // ).thenAnswer((invocation) async {
      //   print(invocation.namedArguments);

      //   return const Right(null);
      // });

      // Act
      final result = await usecase.call(
        params,
        //  const CreateUserParams(
        //     createdAt: 'createdAt',
        //     name: 'name',
        //     avatar: 'avatar',
        //   ),
      );

      // Assert
      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}

// class Football {}



// import 'package:test/test.dart'; 
// import 'package:tdd/src/authentication/domain/usercases/create_user.dart';

// void main() {
// 	group(
// 		create_user_test, 
// 		() {
// 			test(
// 				'',
// 				() async {
// 				},
// 			);
// 		},
// 	);
// }
