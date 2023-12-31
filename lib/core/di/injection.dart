import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:intermediate_flutter_story_app/data/remotedatasource/remotedata_source.dart';
import 'package:intermediate_flutter_story_app/data/repository/repository_impl.dart';
import 'package:intermediate_flutter_story_app/presentation/provider/auth_provider.dart';
import 'package:intermediate_flutter_story_app/presentation/provider/story_provider.dart';

import '../../domain/repository/repository.dart';

final locator = GetIt.instance;
Future init() async {

  // provider
  locator.registerLazySingleton(
          () => AuthProvider(
          repository: locator()
      )
  );
  locator.registerLazySingleton(
          () => StoryProvider(
          repository: locator()
      )
  );

  // repository
  locator.registerLazySingleton<Repository>(
          () => RepositoryImpl(
              remoteDataSource: locator()
          )
  );

  // remote data source
  locator.registerLazySingleton<RemoteDataSource>(
          () => RemoteDataSourceImpl(
          dio: locator()
      )
  );

  // external
  locator.registerLazySingleton(
          () => Dio()
  );
}