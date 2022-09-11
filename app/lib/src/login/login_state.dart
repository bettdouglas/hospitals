import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading(String msg) = _Loading;
  const factory LoginState.loggedIn(User user) = _LoggedIn;
  const factory LoginState.failure(String msg, StackTrace? st) = _Failure;
}
