import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:injectable/injectable.dart';

@module
abstract class BleService {
  @lazySingleton
  FlutterReactiveBle get firebaseAuth => FlutterReactiveBle();
}
