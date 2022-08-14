import 'package:auction_clean_architecture/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:auction_clean_architecture/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:auction_clean_architecture/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:auction_clean_architecture/features/posts/domain/repositories/posts_repository.dart';
import 'package:auction_clean_architecture/features/posts/domain/usecases/add_post_usecase.dart';
import 'package:auction_clean_architecture/features/posts/domain/usecases/delete_post_usecase.dart';
import 'package:auction_clean_architecture/features/posts/domain/usecases/get_all_posts_usecase.dart';
import 'package:auction_clean_architecture/features/posts/domain/usecases/update_post_usecase.dart';
import 'package:auction_clean_architecture/features/posts/presentation/blocs/posts_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //  bloc
  //
  sl.registerFactory(() => PostsBloc(
      getAllPosts: sl(), addPost: sl(), deletePost: sl(), updatePost: sl()));
// usecase
//
  sl.registerLazySingleton(() => GetAllPostsUseCase(sl()));
  sl.registerLazySingleton(() => AddPostUseCase(sl()));
  sl.registerLazySingleton(() => DeletePostUseCase(sl()));
  sl.registerLazySingleton(() => UpdatePostUsecase(sl()));
//reposetory
//
  sl.registerLazySingleton<PostsRepository>(() => PostsRepositoryImpl(
      remoteDataSource: sl(), networkInfo: sl(), localDataSource: sl()));

  sl.registerLazySingleton<PostsRemoteDataSource>(
      () => PostsRemoteDataSourceImpl());
  sl.registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DataConnectionChecker());
}
