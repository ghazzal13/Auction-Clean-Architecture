import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  @override
  List<Object> get props => [];
}

class CacheFailure extends Failure {}

class OfflineFailure extends Failure {
  @override
  List<Object> get props => [];
}

class EmptyCacheFailure extends Failure {
  @override
  List<Object> get props => [];
}
