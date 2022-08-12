abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class AuthGetUserLoadingState extends AuthStates {}

class AuthGetUserSuccessState extends AuthStates {}

class AuthGetUserErrorState extends AuthStates {
  final String error;

  AuthGetUserErrorState(this.error);
}
