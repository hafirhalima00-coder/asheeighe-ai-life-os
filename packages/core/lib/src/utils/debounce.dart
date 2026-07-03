import 'dart:async';

typedef DebounceCallback = void Function();

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 400)});

  void call(DebounceCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
  }

  void flush() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isPending => _timer?.isActive ?? false;
}

class Throttler {
  final Duration interval;
  DateTime? _lastCallTime;

  Throttler({this.interval = const Duration(milliseconds: 300)});

  bool call() {
    final now = DateTime.now();
    if (_lastCallTime == null ||
        now.difference(_lastCallTime!) >= interval) {
      _lastCallTime = now;
      return true;
    }
    return false;
  }

  void reset() {
    _lastCallTime = null;
  }
}
