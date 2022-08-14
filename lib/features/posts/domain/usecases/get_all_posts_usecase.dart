import 'package:dartz/dartz.dart';
import 'package:auction_clean_architecture/core/error/failures.dart';
import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';
import 'package:auction_clean_architecture/features/posts/domain/repositories/posts_repository.dart';

class GetAllPostsUseCase {
  final PostsRepository repository;

  GetAllPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PostsEntity>>> call() async {
    return await repository.getAllPosts();
  }
}
