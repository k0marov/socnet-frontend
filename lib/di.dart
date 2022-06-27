import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socnet/auth_gate/bloc/auth_gate_bloc.dart';
import 'package:socnet/features/auth/data/datasources/hasher_datasource.dart';
import 'package:socnet/features/auth/data/datasources/local_token_datasource.dart';
import 'package:socnet/features/auth/data/datasources/network_auth_datasource.dart';
import 'package:socnet/features/auth/domain/repositories/auth_repository.dart';
import 'package:socnet/features/auth/domain/usecases/get_auth_token_usecase.dart';
import 'package:socnet/features/auth/domain/usecases/login_usecase.dart';
import 'package:socnet/features/auth/domain/usecases/logout_usecase.dart';
import 'package:socnet/features/auth/domain/usecases/register_usecase.dart';
import 'package:socnet/features/auth/presentation/bloc/auth_page_bloc.dart';
import 'package:socnet/features/profile/data/datasources/profile_network_datasource.dart';
import 'package:socnet/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:socnet/features/profile/domain/repositories/profile_repository.dart';
import 'package:socnet/features/profile/domain/usecases/get_follows.dart';
import 'package:socnet/features/profile/domain/usecases/get_my_profile.dart';
import 'package:socnet/features/profile/domain/usecases/update_avatar.dart';
import 'package:socnet/features/profile/domain/usecases/update_profile.dart';
import 'package:socnet/features/profile/presentation/my_profile/bloc/my_profile_bloc.dart';

import 'core/facades/authenticated_api_facade.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

final sl = GetIt.instance;

Future initialize() async {
  //! Core
  sl.registerFactory(() => AuthGateBloc(sl(), sl(), sl()));
  sl.registerLazySingleton(() => AuthenticatedAPIFacade(sl()));
  //! Auth
  // usecases
  sl.registerLazySingleton(() => GetAuthTokenUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  // datasources
  sl.registerLazySingleton<LocalTokenDataSource>(() => LocalTokenDataSourceImpl(sl()));
  sl.registerLazySingleton<NetworkAuthDataSource>(() => NetworkAuthDataSourceImpl(sl()));
  sl.registerLazySingleton<HasherDataSource>(
    () => HasherDataSourceImpl(FlutterBcrypt.salt, FlutterBcrypt.hashPw),
  );
  // repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl(), sl()));

  // blocs
  // yes, this is a singleton, because it is not actually a bloc, but a wrapper for bloc creator
  sl.registerLazySingleton(() => AuthPageBlocCreator(sl(), sl()));

  //! Profile
  // usecases
  sl.registerLazySingleton(() => GetFollows(sl()));
  sl.registerLazySingleton(() => GetMyProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => UpdateAvatar(sl()));
  // datasources
  sl.registerLazySingleton<ProfileNetworkDataSource>(() => ProfileNetworkDataSourceImpl(sl()));
  // repositories
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));
  // blocs
  sl.registerFactory(() => MyProfileBloc(sl(), sl(), sl()));

  //! External
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerSingleton(sharedPrefs);
  sl.registerLazySingleton(() => http.Client());
}
