import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:my_ble_scanner/features/ble/domain/repositories/ble_repository.dart';

part 'ble_cubit.freezed.dart';
part 'ble_state.dart';

class BleCubit extends Cubit<BleState> {
  final BleRepository bleRepository;
  StreamSubscription? _streamSubscription;
  BleCubit({
    required this.bleRepository,
  }) : super(const BleState.initial());

  void scan() async {
    _updateState();

    final failureOrDevicesStream = bleRepository.getDevicesStream();
    await failureOrDevicesStream.fold(
      (failure) async => emit(BleState.error(message: failure.message)),
      (devicesStream) async {
        _streamSubscription = devicesStream.listen((discoveredDevice) {
          _updateState(device: discoveredDevice);
        }, onError: (_) {
          emit(const BleState.error(message: 'BLE Error'));
        }, onDone: () {
          _updateState(isScanning: false);
        });
      },
    );

    Future.delayed(
      const Duration(seconds: 10),
      () => _updateState(isScanning: false),
    );
  }

  void _updateState({DiscoveredDevice? device, bool isScanning = true}) {
    if (device == null) {
      if (!isScanning) {
        _streamSubscription?.cancel();
      }
      final List<DiscoveredDevice> devices = state.maybeMap(
        scanner: (state) => state.devices,
        orElse: () => [],
      );
      emit(BleState.scanner(devices: devices, isScanning: isScanning));
    } else {
      if (device.name.isNotEmpty) {
        state.maybeMap(
          scanner: (state) {
            emit(
              state.copyWith(
                devices: [...state.devices, device],
                isScanning: isScanning,
              ),
            );
          },
          orElse: () => emit(
            BleState.scanner(devices: [device], isScanning: isScanning),
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
