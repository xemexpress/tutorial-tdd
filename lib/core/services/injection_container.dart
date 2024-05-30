import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tdd/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd/src/authentication/domain/usercases/create_user.dart';
import 'package:tdd/src/authentication/domain/usercases/get_users.dart';
import 'package:tdd/src/authentication/presentation/cubit/authentication_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl

    // App logic
    ..registerFactory(
      () => AuthenticationCubit(
        createUser: sl(),
        getUsers: sl(),
      ),
    )

    // Use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))

    // Repository
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))

    // Data sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImplementation(sl()))

    // External dependencies
    ..registerLazySingleton<http.Client>(http.Client.new);
  // ..registerLazySingleton<http.Client>(() => http.Client());
}
