part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAllPostsEvent extends PostsEvent {}

class RefreshPostsEvent extends PostsEvent {}

class AddPostEvent extends PostsEvent {
  final PostsEntity post;

  AddPostEvent({
    required this.post,
  });
  @override
  List<Object> get props => [post];
}

class UpdatePostEvent extends PostsEvent {
  final PostsEntity post;

  UpdatePostEvent({required this.post});
  @override
  List<Object> get props => [post];
}

class DeletePostEvent extends PostsEvent {
  final String postid;

  DeletePostEvent({required this.postid});
  @override
  List<Object> get props => [postid];
}
