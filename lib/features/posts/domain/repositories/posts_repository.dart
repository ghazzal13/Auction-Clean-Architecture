import 'package:dartz/dartz.dart';
import 'package:auction_clean_architecture/core/error/failures.dart';
import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostsEntity>>> getAllPosts();
  Future<Either<Failure, Unit>> addPost(PostsEntity post);
  Future<Either<Failure, Unit>> updatePost(PostsEntity post);
  Future<Either<Failure, Unit>> deletePost(String postid);
}
