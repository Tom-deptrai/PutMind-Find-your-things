/// Serializes async camera operations so dispose and initialize never overlap.
///
/// Android camera hardware often fails when a new [CameraController.initialize]
/// starts while a previous controller is still releasing.
class CameraSessionGate {
  Future<void> _tail = Future<void>.value();
  int _activeOps = 0;

  /// Number of operations currently running or queued (includes the running one).
  int get pendingCount => _activeOps;

  /// True while any operation is in-flight (running or waiting on the chain).
  bool get isBusy => _activeOps > 0;

  /// Runs [action] strictly after all previously enqueued actions complete.
  Future<T> run<T>(Future<T> Function() action) {
    _activeOps++;
    final future = _tail.then((_) => action());
    _tail = future.then<void>((_) {}, onError: (_) {}).whenComplete(() {
      _activeOps--;
    });
    return future;
  }
}
