import 'package:get_it/get_it.dart';
import 'package:trip/repository/google_maps/place_api_client.dart';
import 'package:trip/repository/shared_holder.dart';
import 'package:trip/service/auth_service.dart';
import 'package:trip/service/bookmark_service.dart';
import 'package:trip/service/plan_service.dart';
import 'package:trip/service/poi_service.dart';
import 'package:trip/service/shared_text_analyzer.dart';
import 'package:trip/service/spot_service.dart';
import 'package:trip/service/user_service.dart';

import '../repository/firestore/firestore_client.dart';

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

    getIt.registerSingleton(FirestoreClient());
    getIt.registerSingleton(PlaceApiClient());

    getIt.registerSingleton(AuthService());
    getIt.registerSingleton(SharedTextAnalyzer());
    getIt.registerSingleton(BookmarkService());

    getIt.registerSingleton(UserService());
    getIt.registerSingleton(PlanService());
    getIt.registerSingleton(SpotService());
    getIt.registerSingleton(PoiService());
  }
}
