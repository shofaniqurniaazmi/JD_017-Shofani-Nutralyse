import 'package:firebase_auth/firebase_auth.dart';

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  weakPassword,
  undefined,
  invalidCredentials,
}

class AuthExceptionHandler {
  static AuthResultStatus handleException(FirebaseAuthException e) {
    final AuthResultStatus status;
    switch (e.code) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "expired-action-code":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "reCAPTCHA-check-failed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case "invalid-credential":
        status = AuthResultStatus.invalidCredentials;
        break;
      default:
        status = AuthResultStatus.undefined;
        break;
    }
    return status;
  }

  static String generateExceptionMessage(AuthResultStatus exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address is invalid.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email does not exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.weakPassword:
        errorMessage = "Your password is too weak.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with email and password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage = "An account already exists for that email.";
        break;
      case AuthResultStatus.invalidCredentials:
        errorMessage = "Email or Password not found";
        break;
      default:
        errorMessage = "An undefined error occurred";
        break;
    }
    return errorMessage;
  }
}
