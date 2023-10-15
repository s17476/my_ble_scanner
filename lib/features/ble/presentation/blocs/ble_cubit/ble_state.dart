part of 'ble_cubit.dart';

@freezed
class BleState with _$BleState {
  const factory BleState.initial() = _Initial;
  const factory BleState.error({
    required String message,
  }) = _Error;
  const factory BleState.scanner({
    required List<DiscoveredDevice> devices,
    required bool isScanning,
  }) = _Scanner;
}
