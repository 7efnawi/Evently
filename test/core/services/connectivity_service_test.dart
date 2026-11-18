import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:evently/core/services/connectivity_service.dart';

class _MockConnectivity implements Connectivity {
  List<ConnectivityResult> currentResults = [ConnectivityResult.wifi];
  final _controller = StreamController<List<ConnectivityResult>>.broadcast();

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => currentResults;

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _controller.stream;

  void emit(List<ConnectivityResult> results) {
    currentResults = results;
    _controller.add(results);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  late _MockConnectivity mockConnectivity;
  late ConnectivityService service;

  setUp(() {
    mockConnectivity = _MockConnectivity();
    service = ConnectivityService(connectivity: mockConnectivity);
  });

  tearDown(() {
    mockConnectivity.dispose();
  });

  group('ConnectivityService Tests', () {
    test('isConnected returns true when connected to WiFi or mobile', () async {
      mockConnectivity.currentResults = [ConnectivityResult.wifi];
      expect(await service.isConnected, isTrue);

      mockConnectivity.currentResults = [ConnectivityResult.mobile];
      expect(await service.isConnected, isTrue);
    });

    test('isConnected returns false when none', () async {
      mockConnectivity.currentResults = [ConnectivityResult.none];
      expect(await service.isConnected, isFalse);
    });

    test('onConnectivityChanged emits boolean connectivity transitions', () async {
      final expectation = expectLater(
        service.onConnectivityChanged,
        emitsInOrder([false, true]),
      );

      mockConnectivity.emit([ConnectivityResult.none]);
      mockConnectivity.emit([ConnectivityResult.wifi]);

      await expectation;
    });
  });
}
