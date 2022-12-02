import 'package:auction_clean_architecture/features/authentication/cubit/user.dart';
import 'package:auction_clean_architecture/features/posts/domain/usecases/add_post_usecase.dart';
import 'package:auction_clean_architecture/features/posts/domain/usecases/delete_post_usecase.dart';
import 'package:auction_clean_architecture/features/posts/domain/usecases/update_post_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';
import 'package:auction_clean_architecture/features/posts/domain/usecases/get_all_posts_usecase.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/strings/messages.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostsUseCase getAllPosts;
  final AddPostUseCase addPost;
  final UpdatePostUsecase updatePost;
  final DeletePostUseCase deletePost;
  PostsBloc({
    required this.getAllPosts,
    required this.addPost,
    required this.updatePost,
    required this.deletePost,
  }) : super(PostInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        emit(LoadingPostsState());
        final failureOrPosts = await getAllPosts();

        emit(_mapFailureOrPostsToState(failureOrPosts));
      } else if (event is RefreshPostsEvent) {
        emit(LoadingPostsState());

        final failureOrPosts = await getAllPosts();
        emit(_mapFailureOrPostsToState(failureOrPosts));
      } else if (event is AddPostEvent) {
        emit(LoadingAddUpdateDeletePostState());
        final failureOrDoneMessage = await addPost(
          event.post,
        );
        ADD_DELETE_UPDATE(failureOrDoneMessage, ADD_SUCCESS_MESSAGE);
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddUpdateDeletePostState());
        final failureOrDoneMessage = await updatePost(event.post);
        ADD_DELETE_UPDATE(failureOrDoneMessage, UPDATE_SUCCESS_MESSAGE);
      } else if (event is DeletePostEvent) {
        emit(LoadingAddUpdateDeletePostState());
        final failureOrDoneMessage = await deletePost(event.postid);
        ADD_DELETE_UPDATE(failureOrDoneMessage, DELETE_SUCCESS_MESSAGE);
      }
    });
  }

  PostsState ADD_DELETE_UPDATE(Either<Failure, Unit> either, String message) {
    return either.fold(
        (failure) => ErrorAddUpdateDeletePostState(
              message: _mapFailureToMessage(failure),
            ),
        (_) => MessageAddUpdateDeletePostState(message: message));
  }

  PostsState _mapFailureOrPostsToState(
      Either<Failure, List<PostsEntity>> either) {
    return either.fold(
      (failure) => ErrorPostsState(message: _mapFailureToMessage(failure)),
      (posts) => LoadedPostsState(
        posts: posts,
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      default:
        return "UnExpected Error, Plase Try Agen Later ";
    }
  }

  UserModel userData = UserModel();
  void getUserData(id) {
    FirebaseFirestore.instance.collection("users").doc(id).get().then((value) {
      print(value.data());
      userData = UserModel.fromMap(value.data());
    }).catchError((error) {});
    // return userData;
  }
}
