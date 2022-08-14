import 'package:auction_clean_architecture/core/network/network_info.dart';
import 'package:auction_clean_architecture/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:auction_clean_architecture/features/posts/data/models/posts_model.dart';
import 'package:dartz/dartz.dart';
import 'package:auction_clean_architecture/core/error/failures.dart';
import 'package:auction_clean_architecture/core/error/exceptions.dart';
import 'package:auction_clean_architecture/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';
import 'package:auction_clean_architecture/features/posts/domain/repositories/posts_repository.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class PostsRepositoryImpl implements PostsRepository {
  PostsRemoteDataSource remoteDataSource;
  NetworkInfo networkInfo;
  PostLocalDataSource localDataSource;
  PostsRepositoryImpl(
      {required this.remoteDataSource,
      required this.networkInfo,
      required this.localDataSource});

  @override
  Future<Either<Failure, List<PostsEntity>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPosts();
        localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(
    PostsEntity post,
  ) async {
    final PostModel postModel = PostModel(
        name: post.name,
        uid: post.uid,
        image: post.image,
        postImage: post.postImage,
        postId: post.postId,
        price: post.price,
        titel: post.titel,
        startdate: post.startdate,
        enddate: post.enddate,
        postTime: post.postTime,
        category: post.category,
        description: post.description,
        winner: post.winner,
        winnerID: post.winnerID);

    return await _getMessage(() {
      return remoteDataSource.addPost(postModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deletePost(String postId) async {
    return await _getMessage(() {
      return remoteDataSource.deletePost(postId);
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePost(PostsEntity post) async {
    final PostModel postModel = PostModel(
        name: post.name,
        uid: post.uid,
        image: post.image,
        postImage: post.postImage,
        postId: post.postId,
        price: post.price,
        titel: post.titel,
        startdate: post.startdate,
        enddate: post.enddate,
        postTime: post.postTime,
        category: post.category,
        description: post.description,
        winner: post.winner,
        winnerID: post.winnerID);
    return await _getMessage(() {
      return remoteDataSource.updatePost(postModel);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
