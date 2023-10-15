import 'package:dartz/dartz.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:my_ble_scanner/core/errors/failure.dart';

abstract class BleRepository {
  Either<Failure, Stream<DiscoveredDevice>> getDevicesStream();
}
