import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_ble_scanner/features/ble/presentation/blocs/ble_cubit/ble_cubit.dart';
import 'package:my_ble_scanner/injection.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'My BLE Scanner';
    return BlocProvider(
      create: (context) => getIt.get<BleCubit>(),
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          appBarTheme: const AppBarTheme(foregroundColor: Colors.white),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: title),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BleCubit, BleState>(
      builder: (context, state) {
        final isScanning = state.maybeMap(
          scanner: (state) => state.isScanning,
          orElse: () => false,
        );
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(title),
            centerTitle: false,
            actions: [
              if (isScanning)
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
              const SizedBox(
                width: 8,
              )
            ],
          ),
          body: state.map(
            initial: (_) => const Center(
              child: Text('Initial'),
            ),
            error: (state) => Center(
              child: Text('Error: ${state.message}'),
            ),
            scanner: (state) {
              final devices = state.devices;
              return ListView.separated(
                itemCount: devices.length,
                itemBuilder: (context, index) => Text(devices[index].name),
                separatorBuilder: (_, __) => const Divider(),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: isScanning
                ? context.read<BleCubit>().stop
                : context.read<BleCubit>().scan,
            tooltip: isScanning ? 'Stop' : 'Scan',
            child: Icon(
              isScanning ? Icons.stop : Icons.refresh,
            ),
          ),
        );
      },
    );
  }
}
