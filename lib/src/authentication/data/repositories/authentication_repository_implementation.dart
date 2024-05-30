import 'package:dartz/dartz.dart';
import 'package:tdd/core/errors/exceptions.dart';
import 'package:tdd/core/errors/failure.dart';
import 'package:tdd/core/utils/typedef.dart';
import 'package:tdd/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd/src/authentication/data/models/user_model.dart';
import 'package:tdd/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  AuthenticationRepositoryImplementation(this._dataSource);

  final AuthenticationRemoteDataSource _dataSource;

  @override
  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // Test-driven development
    // 1) Check if the right dependencies are being used
    // 2) Check if proper results are being returned.
    //  2.1) Check when things went smooth, the actual expected result is returned. (the test of this might join with 1)
    //  2.2) Check when exceptions thrown, the right failure comes up.
    try {
      await _dataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
    } on APIException catch (e) {
      return Left(
        APIFailure.fromException(e),
      );
    }

    return const Right(null);
  }

  @override
  ResultFuture<List<UserModel>> getUsers() async {
    // 1. Check when everything goes smooth, the actual expected result is returned from the dependency called once.
    // 2. Check when exceptions thrown, the right failure comes up.
    try {
      final users = await _dataSource.getUsers();

      return Right(users);
    } on APIException catch (e) {
      return Left(
        APIFailure.fromException(e),
      );
    }
  }
}
