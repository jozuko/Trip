import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/repository/shared_holder.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
enum AuthProvider {
  email,
  google,
}

class AuthService {
  static final _auth = FirebaseAuth.instanceFor(app: Firebase.app(), persistence: Persistence.LOCAL);
  final sharedHolder = getIt.get<SharedHolder>();

  User? get user => _auth.currentUser;

  AuthProvider get authProvider => sharedHolder.authProvider;

  void initialize() {
    _auth.userChanges().listen(onChangeUser);
  }

  void onChangeUser(User? user) {
    if (user == null) {
      TripLog.i('AuthService::onChangeAuthState user signed out');
    } else {
      TripLog.i('AuthService::onChangeAuthState user signed in');
    }
  }

  Future<AuthResult> authWithMail(String email, String password) async {
    final result = await _signInWithEmailAndPassword(email, password);
    if (result == AuthResult.userNotFound) {
      return await _createUserWithEmailAndPassword(email, password);
    }
    return result;
  }

  Future<void> signOut() async {
    TripLog.i('AuthService::signOut');
    await _auth.signOut();
  }

  Future<AuthResult> _signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        TripLog.i('AuthService::signInWithEmailAndPassword success.');
        sharedHolder.authProvider = AuthProvider.email;
        return AuthResult.success;
      } else {
        TripLog.i('AuthService::signInWithEmailAndPassword failed.');
        return AuthResult.failedEmail;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        TripLog.i('AuthService::signInWithEmailAndPassword No user found for that email.', e);
        return AuthResult.userNotFound;
      } else if (e.code == 'wrong-password') {
        TripLog.e('AuthService::signInWithEmailAndPassword Wrong password provided for that user.', e);
        return AuthResult.wrongPassword;
      } else {
        TripLog.e('AuthService::signInWithEmailAndPassword', e);
        return AuthResult.failedEmail;
      }
    } catch (e) {
      TripLog.e('AuthService::signInWithEmailAndPassword', e);
      return AuthResult.failedEmail;
    }
  }

  Future<AuthResult> _createUserWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        TripLog.i('AuthService::createUserWithEmailAndPassword success.');
        sharedHolder.authProvider = AuthProvider.email;
        return AuthResult.success;
      } else {
        TripLog.e('AuthService::createUserWithEmailAndPassword failed.');
        return AuthResult.failedEmail;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        TripLog.i('AuthService::createUserWithEmailAndPassword The password provided is too weak.', e);
        return AuthResult.weekPassword;
      } else if (e.code == 'email-already-in-use') {
        TripLog.e('AuthService::createUserWithEmailAndPassword The account already exists for that email.', e);
        return AuthResult.failedEmail;
      } else {
        TripLog.e('AuthService::createUserWithEmailAndPassword', e);
        return AuthResult.failedEmail;
      }
    } catch (e) {
      TripLog.e('AuthService::createUserWithEmailAndPassword', e);
      return AuthResult.failedEmail;
    }
  }

  Future<AuthResult> authWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        TripLog.i('AuthService::authWithGoogle success');
        return AuthResult.success;
      } else {
        TripLog.e('AuthService::authWithGoogle failed.');
        return AuthResult.failedGoogle;
      }
    } catch (e) {
      TripLog.e('AuthService::authWithGoogle', e);
      return AuthResult.failedGoogle;
    }
  }
}

enum AuthResult {
  success,
  weekPassword,
  userNotFound,
  wrongPassword,
  failedEmail,
  failedGoogle,
}
