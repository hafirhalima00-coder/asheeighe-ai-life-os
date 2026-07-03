import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce({required this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isActive => _timer?.isActive ?? false;
}

class Throttle {
  final Duration interval;
  Timer? _timer;
  DateTime? _lastRun;

  Throttle({required this.interval});

  void call(void Function() action) {
    final now = DateTime.now();
    if (_lastRun != null &&
        now.difference(_lastRun!).inMilliseconds < interval.inMilliseconds) {
      return;
    }
    _lastRun = now;
    action();
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

void main() {
  group('Debounce', () {
    late Debounce debounce;

    setUp(() {
      debounce = Debounce(delay: const Duration(milliseconds: 100));
    });

    tearDown(() {
      debounce.cancel();
    });

    test('should not execute immediately', () {
      bool executed = false;
      debounce(() => executed = true);
      expect(executed, false);
    });

    test('should execute after delay', () async {
      bool executed = false;
      debounce(() => executed = true);
      await Future.delayed(const Duration(milliseconds: 150));
      expect(executed, true);
    });

    test('should reset on repeated calls', () async {
      int callCount = 0;
      debounce(() => callCount++);
      debounce(() => callCount++);
      debounce(() => callCount++);
      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1);
    });

    test('isActive should be true while timer is pending', () {
      debounce(() {});
      expect(debounce.isActive, true);
    });

    test('isActive should be false after execution', () async {
      debounce(() {});
      await Future.delayed(const Duration(milliseconds: 150));
      expect(debounce.isActive, false);
    });

    test('cancel should stop pending execution', () async {
      bool executed = false;
      debounce(() => executed = true);
      debounce.cancel();
      expect(debounce.isActive, false);
      await Future.delayed(const Duration(milliseconds: 150));
      expect(executed, false);
    });

    test('should work with zero delay', () async {
      final instantDebounce = Debounce(delay: Duration.zero);
      bool executed = false;
      instantDebounce(() => executed = true);
      await Future.delayed(const Duration(milliseconds: 10));
      expect(executed, true);
      instantDebounce.cancel();
    });

    test('should handle multiple debounces sequentially', () async {
      int callCount = 0;
      debounce(() => callCount++);
      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1);
      debounce(() => callCount++);
      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 2);
    });
  });

  group('Throttle', () {
    late Throttle throttle;

    setUp(() {
      throttle = Throttle(interval: const Duration(milliseconds: 100));
    });

    tearDown(() {
      throttle.dispose();
    });

    test('should execute first call immediately', () {
      bool executed = false;
      throttle(() => executed = true);
      expect(executed, true);
    });

    test('should ignore calls within interval', () {
      int callCount = 0;
      throttle(() => callCount++);
      throttle(() => callCount++);
      throttle(() => callCount++);
      expect(callCount, 1);
    });

    test('should execute again after interval passes', () async {
      int callCount = 0;
      throttle(() => callCount++);
      await Future.delayed(const Duration(milliseconds: 150));
      throttle(() => callCount++);
      expect(callCount, 2);
    });
  });
}
