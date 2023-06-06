import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc_lab_2_app_with_notes/model.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  // We need these lines to make the LoginApi class singleton
  // const LoginApi._sharedInstance();
  // static const LoginApi _shared = LoginApi._sharedInstance();
  // factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) {
    return Future.delayed(
      const Duration(seconds: 2),
      () => email == 'foo@bar.com' && password == 'foobar',
    ).then(
      (isLoggedIn) => isLoggedIn ? const LoginHandle.fooBar() : null,
    );
  }
}
