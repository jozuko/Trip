import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/repository/shared_holder.dart';
import 'package:trip/service/plan_service.dart';
import 'package:trip/service/poi_service.dart';
import 'package:trip/service/spot_service.dart';
import 'package:trip/service/user_service.dart';
import 'package:trip/util/global.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
enum AuthProvider {
  email,
  google,
  apple,
}

class AuthService {
  static final _auth = FirebaseAuth.instanceFor(app: Firebase.app(), persistence: Persistence.LOCAL);
  final sharedHolder = getIt.get<SharedHolder>();
  bool isInitialized = false;

  User? get user => _auth.currentUser;

  AuthProvider get authProvider => sharedHolder.authProvider;

  void initialize(void Function(User? user)? callback) {
    isInitialized = true;
    _auth.userChanges().listen((user) {
      callback?.call(user);
    });
  }

  Future<AuthResultMail> authWithMail(String email, String password) async {
    final result = await _signInWithEmailAndPassword(email, password);
    if (result == AuthResultMail.userNotFound) {
      return await _createUserWithEmailAndPassword(email, password);
    }
    return result;
  }

  Future<void> signOut() async {
    TripLog.i('AuthService::signOut');
    await _auth.signOut();
    if (sharedHolder.authProvider == AuthProvider.google) {
      await GoogleSignIn().signOut();
    }

    await _auth.signOut();
    getIt.get<UserService>().dispose();
    getIt.get<SpotService>().dispose();
    getIt.get<PlanService>().dispose();
    getIt.get<PoiService>().dispose();
    sharedHolder.userId = null;
  }

  Future<AuthResultMail> _signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final authUser = userCredential.user;
      if (authUser != null) {
        TripLog.i('AuthService::signInWithEmailAndPassword success.');
        sharedHolder.authProvider = AuthProvider.email;
        sharedHolder.userId = authUser.uid;

        return AuthResultMail.success;
      } else {
        TripLog.i('AuthService::signInWithEmailAndPassword failed.');
        return AuthResultMail.failed;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        TripLog.i('AuthService::signInWithEmailAndPassword No user found for that email.', e);
        return AuthResultMail.userNotFound;
      } else if (e.code == 'wrong-password') {
        TripLog.e('AuthService::signInWithEmailAndPassword Wrong password provided for that user.', e);
        return AuthResultMail.wrongPassword;
      } else {
        TripLog.e('AuthService::signInWithEmailAndPassword', e);
        return AuthResultMail.failed;
      }
    } catch (e) {
      TripLog.e('AuthService::signInWithEmailAndPassword', e);
      return AuthResultMail.failed;
    }
  }

  Future<AuthResultMail> _createUserWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final authUser = userCredential.user;
      if (authUser != null) {
        TripLog.i('AuthService::createUserWithEmailAndPassword success.');
        sharedHolder.authProvider = AuthProvider.email;
        sharedHolder.userId = authUser.uid;

        return AuthResultMail.success;
      } else {
        TripLog.e('AuthService::createUserWithEmailAndPassword failed.');
        return AuthResultMail.failed;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        TripLog.i('AuthService::createUserWithEmailAndPassword The password provided is too weak.', e);
        return AuthResultMail.weekPassword;
      } else if (e.code == 'email-already-in-use') {
        TripLog.e('AuthService::createUserWithEmailAndPassword The account already exists for that email.', e);
        return AuthResultMail.failed;
      } else {
        TripLog.e('AuthService::createUserWithEmailAndPassword', e);
        return AuthResultMail.failed;
      }
    } catch (e) {
      TripLog.e('AuthService::createUserWithEmailAndPassword', e);
      return AuthResultMail.failed;
    }
  }

  Future<AuthResultThirdParty> authWithGoogle() async {
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
      final userCredential = await _auth.signInWithCredential(credential);
      final authUser = userCredential.user;
      if (authUser == null) {
        TripLog.e('AuthService::authWithGoogle failed.');
        return AuthResultThirdParty.failed;
      } else {
        TripLog.i('AuthService::authWithGoogle success');
        sharedHolder.authProvider = AuthProvider.google;
        sharedHolder.userId = authUser.uid;

        return AuthResultThirdParty.success;
      }
    } catch (e) {
      TripLog.e('AuthService::authWithGoogle', e);
      return AuthResultThirdParty.failed;
    }
  }

  Future<AuthResultThirdParty> authWithApple() async {
    final appleProvider = AppleAuthProvider();

    try {
      final UserCredential? userCredential;
      if (kIsWeb) {
        userCredential = await _auth.signInWithPopup(appleProvider);
      } else {
        userCredential = await _auth.signInWithProvider(appleProvider);
      }
      final authUser = userCredential.user;
      if (authUser == null) {
        TripLog.e('AuthService::authWithApple failed.');
        return AuthResultThirdParty.failed;
      } else {
        TripLog.i('AuthService::authWithApple success');
        sharedHolder.authProvider = AuthProvider.apple;
        sharedHolder.userId = authUser.uid;

        return AuthResultThirdParty.success;
      }
    } catch (e) {
      TripLog.e('AuthService::authWithApple', e);
      return AuthResultThirdParty.failed;
    }
  }
}

enum AuthResultMail {
  success,
  weekPassword,
  userNotFound,
  wrongPassword,
  failed,
}

enum AuthResultThirdParty {
  success,
  failed,
}
