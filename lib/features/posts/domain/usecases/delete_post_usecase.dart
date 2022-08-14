import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';
import 'package:auction_clean_architecture/features/posts/domain/repositories/posts_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class DeletePostUseCase {
  final PostsRepository repository;

  DeletePostUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String postid) async {
    return await repository.deletePost(postid);
  }
}
