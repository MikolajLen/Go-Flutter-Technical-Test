import 'custom_app_injector.dart' as _i1;
import 'dart:async' as _i2;
import '../main.dart' as _i3;
import '../db/file_manager.dart' as _i4;

class CustomAppInjector$Injector implements _i1.CustomAppInjector {
  CustomAppInjector$Injector._();

  static _i2.Future<_i1.CustomAppInjector> create() async {
    final injector = CustomAppInjector$Injector._();

    return injector;
  }

  _i3.MyApp _createMyApp() => _i3.MyApp(_createFileManager);
  _i4.FileManager _createFileManager() => _i4.FileManager();
  @override
  _i3.MyApp get app => _createMyApp();
}
