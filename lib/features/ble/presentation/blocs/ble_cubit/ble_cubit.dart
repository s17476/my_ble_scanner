import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:my_ble_scanner/features/ble/domain/repositories/ble_repository.dart';

part 'ble_cubit.freezed.dart';
part 'ble_state.dart';

@lazySingleton
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
          _updateState(newDevice: discoveredDevice);
        }, onError: (error) {
          _streamSubscription?.cancel();
          emit(BleState.error(message: error.toString()));
        }, onDone: () {
          _updateState(isScanning: false);
        });
      },
    );

    Future.delayed(
      const Duration(seconds: 10),
      () => state.mapOrNull(
        scanner: (state) {
          if (state.isScanning) {
            _updateState(isScanning: false);
          }
        },
      ),
    );
  }

  void _updateState({DiscoveredDevice? newDevice, bool isScanning = true}) {
    if (newDevice == null) {
      if (!isScanning) {
        _streamSubscription?.cancel();
      }
      final List<DiscoveredDevice> devices = state.mapOrNull(
            scanner: (state) {
              if (state.isScanning) {
                return state.devices;
              }
              return null;
            },
          ) ??
          [];
      emit(BleState.scanner(devices: devices, isScanning: isScanning));
    } else {
      if (newDevice.name.isNotEmpty) {
        state.maybeMap(
          scanner: (state) {
            if (!state.devices.any((device) => device.id == newDevice.id)) {
              emit(
                state.copyWith(
                  devices: [...state.devices, newDevice],
                  isScanning: isScanning,
                ),
              );
            }
          },
          orElse: () => emit(
            BleState.scanner(devices: [newDevice], isScanning: isScanning),
          ),
        );
      }
    }
  }

  void stop() => _updateState(isScanning: false);

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
