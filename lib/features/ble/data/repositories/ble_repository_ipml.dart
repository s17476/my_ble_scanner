import 'package:dartz/dartz.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:injectable/injectable.dart';

import 'package:my_ble_scanner/core/errors/failure.dart';
import 'package:my_ble_scanner/features/ble/domain/repositories/ble_repository.dart';

@LazySingleton(as: BleRepository)
class BleRepositoryImpl extends BleRepository {
  final FlutterReactiveBle flutterReactiveBle;

  BleRepositoryImpl({
    required this.flutterReactiveBle,
  });

  @override
  Either<Failure, Stream<DiscoveredDevice>> getDevicesStream() {
    try {
      return right(
        flutterReactiveBle.scanForDevices(
          withServices: [],
          scanMode: ScanMode.lowLatency,
        ),
      );
    } catch (e) {
      return left(Failure.ble(message: e.toString()));
    }
  }
}
