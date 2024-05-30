import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd/core/errors/exceptions.dart';
import 'package:tdd/core/errors/failure.dart';
import 'package:tdd/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd/src/authentication/domain/entities/user.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

const tException = APIException(
  message: 'Unknown Error Occured',
  statusCode: 500,
);

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repositoryImplementation;

  setUp(() {
    remoteDataSource = MockAuthenticationRemoteDataSource();
    repositoryImplementation =
        AuthenticationRepositoryImplementation(remoteDataSource);
  });

  group('createUser', () {
    const createdAt = 'whatever.createdAt';
    const name = 'whatever.name';
    const avatar = 'whatever.avatar';

    test(
      'should call the [AuthenticationRemoteDatasource.createUser]'
      'and complete successfully'
      'when the call to the remote source is successful',
      () async {
        // Arrange
        when(() => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'),
            )).thenAnswer((_) async => Future.value());

        // Act
        final result = await repositoryImplementation.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        // Assert
        expect(result, equals(const Right(null)));
        verify(() => remoteDataSource.createUser(
              createdAt: createdAt,
              name: name,
              avatar: avatar,
            )).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return a [APIFailure] when the call to the remote'
      'source is unsuccessful',
      () async {
        // Arrange
        when(() => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar'),
            )).thenThrow(tException);

        // Act
        final result = await repositoryImplementation.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        // Assert
        expect(
          result,
          equals(
            Left(
              APIFailure.fromException(tException),
            ),
          ),
        );

        // A bit of practice on isA for the expect() function.
        // expect(
        //   result,
        //   isA<Left>().having(
        //     (left) => left.value,
        //     'left',
        //     isA<APIFailure>()
        //         .having(
        //           (failure) => failure.message,
        //           'message',
        //           tException.message,
        //         )
        //         .having(
        //           (failure) => failure.statusCode,
        //           'status code',
        //           tException.statusCode,
        //         ),
        //   ),
        // );

        verify(() => remoteDataSource.createUser(
              createdAt: createdAt,
              name: name,
              avatar: avatar,
            )).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getUsers', () {
    test(
      'should call [AuthenticationRemoteDataSource.getUsers]'
      'and return List<users>'
      'when the call to the remote source is successful',
      () async {
        // Arrange
        when(
          () => remoteDataSource.getUsers(),
        ).thenAnswer(
          (_) async => [],
        );

        // Act
        final result = await repositoryImplementation.getUsers();

        // Assert
        expect(result, isA<Right<dynamic, List<User>>>());
        // expect(result, equals(const Right([])));
        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);

        // // Arrange
        // const users = [UserModel.empty()];

        // when(
        //   () => remoteDataSource.getUsers(),
        // ).thenAnswer(
        //   (_) async => Future.value(users),
        // );

        // // Act
        // final result = await repositoryImplementation.getUsers();

        // // Assert
        // expect(result, equals(const Right(users)));
        // verify(() => remoteDataSource.getUsers()).called(1);
        // verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return a [APIFailure] if the call'
      'to the remote source is unsuccessful',
      () async {
        // Arrange
        when(() => remoteDataSource.getUsers()).thenThrow(tException);

        // Act
        final result = await repositoryImplementation.getUsers();

        // Assert
        expect(
          result,
          equals(
            Left(APIFailure.fromException(tException)),
          ),
        );
        verify(() => remoteDataSource.getUsers()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
