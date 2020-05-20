import 'package:inject/inject.dart';
import '../main.dart';
import 'custom_app_injector.inject.dart' as g;

@Injector()
abstract class CustomAppInjector {

  @provide
  MyApp get app;

  static Future<CustomAppInjector> create() {
    return g.CustomAppInjector$Injector.create();
  }
}
