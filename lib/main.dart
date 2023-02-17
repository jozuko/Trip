import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:trip/di/dependency_injection.dart';
import 'package:trip/firebase_options.dart';
import 'package:trip/repository/log/trip_logger.dart';
import 'package:trip/view/init/application_bloc.dart';
import 'package:trip/view/init/application_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  await DI.register();
  initializeDateFormatting('ja');
  Bloc.observer = SimpleBlocObserver();

  runApp(
    BlocProvider(
      create: (context) => ApplicationBloc(),
      child: const ApplicationPage(),
    ),
  );
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    TripLog.d('Bloc onEvent $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    TripLog.d('Bloc onTransition $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    TripLog.e('Bloc onError', error, stackTrace);
  }
}
