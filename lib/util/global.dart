import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:trip/di/dependency_injection.dart';

///
/// Created by jozuko on 2023/02/16.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class Global {
  Global._();
}

const String appName = '旅行計画を作ろう';
const String googleMapsApiKey = String.fromEnvironment('GOOGLE_API_KEY');

bool get isRelease => const bool.fromEnvironment('dart.vm.product');

GetIt get getIt => DI.getIt;

const double margin = 20.0;
const double marginS = 10.0;

typedef ChangeUserCallback = void Function(User? user);
