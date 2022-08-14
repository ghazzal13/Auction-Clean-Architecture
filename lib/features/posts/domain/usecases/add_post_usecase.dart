import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';
import 'package:auction_clean_architecture/features/posts/domain/repositories/posts_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AddPostUseCase {
  final PostsRepository repository;

  AddPostUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(
    PostsEntity post,
  ) async {
    return await repository.addPost(
      post,
    );
  }
}
