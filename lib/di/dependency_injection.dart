import 'package:get_it/get_it.dart';
import 'package:trip/repository/shared_holder.dart';
import 'package:trip/service/auth_service.dart';
import 'package:trip/service/url_analyzer.dart';

///
/// Created by jozuko on 2023/02/17.
/// Copyright (c) 2023 Studio Jozu. All rights reserved.
///
class DI {
  static GetIt get getIt => GetIt.instance;

  static Future<void> register() async {
    final sharedHolder = SharedHolder();
    await sharedHolder.initialize();
    getIt.registerSingleton(sharedHolder);

    getIt.registerSingleton(AuthService());
    getIt.registerSingleton(UrlAnalyzer());
  }
}
