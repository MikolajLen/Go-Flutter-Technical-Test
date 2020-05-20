import 'package:inject/inject.dart';
import '../main.dart';
import 'custom_app_injector.inject.dart' as injector;

@Injector()
abstract class CustomAppInjector {

  @provide
  MyApp get app;

  static Future<CustomAppInjector> create() {
    return injector.CustomAppInjector$Injector.create();
  }
}
