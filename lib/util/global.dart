import 'package:get_it/get_it.dart';
import 'package:trip/di/dependency_injection.dart';

///
/// Created by jozuko on 2023/02/16.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class Global {
  Global._();

  static const isRelease = bool.fromEnvironment('dart.vm.product');

  static GetIt get getIt => DI.getIt;
}
