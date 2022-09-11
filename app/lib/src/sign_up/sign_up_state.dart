import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _Initial;
  const factory SignUpState.loading(String msg) = _Loading;
  const factory SignUpState.signedUp(User user) = _SignedUp;
  const factory SignUpState.failure(String err, StackTrace st) = _Failure;
}
