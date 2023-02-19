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

const String appName = '旅行プラン作成';

bool get isRelease => const bool.fromEnvironment('dart.vm.product');

GetIt get getIt => DI.getIt;

const double margin = 20.0;
const double marginS = 10.0;

const double fontSize1 = 22.0;
const double fontSize2 = 20.0;
const double fontSize3 = 18.0;
const double fontSize4 = 16.0;
const double fontSize5 = 14.0;

typedef ChangeUserCallback = void Function(User? user);
