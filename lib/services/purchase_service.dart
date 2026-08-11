import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Stable Lifetime product id (Google Play + App Store).
const String kLifetimeProductId = 'putmind_lifetime';

enum PurchasePhase {
  idle,
  loadingProducts,
  ready,
  purchasing,
  restoring,
  success,
  cancelled,
  failed,
  alreadyPurchased,
  restoreNone,
  storeUnavailable,
}

/// Abstraction over store billing so tests can mock entitlement flows.
abstract class PurchaseService {
  Stream<PurchasePhase> get phaseChanges;
  PurchasePhase get phase;
  String? get localizedPrice;
  String? get errorMessage;
  bool get isAvailable;

  Future<void> initialize();
  Future<void> loadProducts();
  Future<void> buyLifetime();
  Future<void> restorePurchases();
  Future<void> dispose();
}

/// Real StoreKit / Play Billing implementation via `in_app_purchase`.
class StorePurchaseService implements PurchaseService {
  StorePurchaseService({InAppPurchase? iap})
    : _iap = iap ?? InAppPurchase.instance;

  final InAppPurchase _iap;
  final _phaseController = StreamController<PurchasePhase>.broadcast();
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  PurchasePhase _phase = PurchasePhase.idle;
  String? _localizedPrice;
  String? _errorMessage;
  bool _available = false;
  ProductDetails? _product;
  Completer<PurchasePhase>? _pending;

  @override
  Stream<PurchasePhase> get phaseChanges => _phaseController.stream;

  @override
  PurchasePhase get phase => _phase;

  @override
  String? get localizedPrice => _localizedPrice;

  @override
  String? get errorMessage => _errorMessage;

  @override
  bool get isAvailable => _available;

  void _setPhase(PurchasePhase phase) {
    _phase = phase;
    if (!_phaseController.isClosed) {
      _phaseController.add(phase);
    }
  }

  @override
  Future<void> initialize() async {
    if (kIsWeb) {
      _available = false;
      _setPhase(PurchasePhase.storeUnavailable);
      return;
    }
    _available = await _iap.isAvailable();
    if (!_available) {
      _setPhase(PurchasePhase.storeUnavailable);
      return;
    }
    _subscription ??= _iap.purchaseStream.listen(
      _onPurchaseUpdates,
      onError: (Object e) {
        _errorMessage = e.toString();
        _setPhase(PurchasePhase.failed);
        _completePending(PurchasePhase.failed);
      },
    );
    await loadProducts();
  }

  @override
  Future<void> loadProducts() async {
    if (!_available) {
      _setPhase(PurchasePhase.storeUnavailable);
      return;
    }
    _setPhase(PurchasePhase.loadingProducts);
    final response = await _iap.queryProductDetails({kLifetimeProductId});
    if (response.error != null || response.productDetails.isEmpty) {
      _errorMessage = response.error?.message ?? 'Product unavailable';
      _product = null;
      _localizedPrice = null;
      _setPhase(PurchasePhase.storeUnavailable);
      return;
    }
    _product = response.productDetails.first;
    _localizedPrice = _product!.price;
    _setPhase(PurchasePhase.ready);
  }

  @override
  Future<void> buyLifetime() async {
    if (_phase == PurchasePhase.purchasing ||
        _phase == PurchasePhase.restoring) {
      return;
    }
    if (!_available || _product == null) {
      await loadProducts();
      if (_product == null) {
        _setPhase(PurchasePhase.storeUnavailable);
        return;
      }
    }
    _errorMessage = null;
    _setPhase(PurchasePhase.purchasing);
    _pending = Completer<PurchasePhase>();
    final param = PurchaseParam(productDetails: _product!);
    final started = await _iap.buyNonConsumable(purchaseParam: param);
    if (!started) {
      _setPhase(PurchasePhase.failed);
      _completePending(PurchasePhase.failed);
      return;
    }
    await _pending!.future.timeout(
      const Duration(minutes: 5),
      onTimeout: () {
        _setPhase(PurchasePhase.failed);
        return PurchasePhase.failed;
      },
    );
  }

  @override
  Future<void> restorePurchases() async {
    if (_phase == PurchasePhase.purchasing ||
        _phase == PurchasePhase.restoring) {
      return;
    }
    if (!_available) {
      _setPhase(PurchasePhase.storeUnavailable);
      return;
    }
    _errorMessage = null;
    _setPhase(PurchasePhase.restoring);
    _pending = Completer<PurchasePhase>();
    try {
      await _iap.restorePurchases();
      await _pending!.future.timeout(
        const Duration(seconds: 45),
        onTimeout: () {
          if (_phase == PurchasePhase.restoring) {
            _setPhase(PurchasePhase.restoreNone);
          }
          return _phase;
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      _setPhase(PurchasePhase.failed);
      _completePending(PurchasePhase.failed);
    }
  }

  Future<void> _onPurchaseUpdates(List<PurchaseDetails> purchases) async {
    var sawLifetime = false;
    for (final purchase in purchases) {
      if (purchase.productID != kLifetimeProductId) continue;
      sawLifetime = true;
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _setPhase(
            _phase == PurchasePhase.restoring
                ? PurchasePhase.restoring
                : PurchasePhase.purchasing,
          );
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          _setPhase(
            purchase.status == PurchaseStatus.restored
                ? PurchasePhase.success
                : PurchasePhase.success,
          );
          // Distinguish already-owned mildly for UI if buy while owned.
          if (_phase == PurchasePhase.purchasing) {
            // kept as success
          }
          _completePending(PurchasePhase.success);
        case PurchaseStatus.error:
          _errorMessage = purchase.error?.message;
          _setPhase(PurchasePhase.failed);
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          _completePending(PurchasePhase.failed);
        case PurchaseStatus.canceled:
          _setPhase(PurchasePhase.cancelled);
          _completePending(PurchasePhase.cancelled);
      }
    }

    if (_phase == PurchasePhase.restoring &&
        !sawLifetime &&
        purchases.isEmpty) {
      // Wait for timeout path or subsequent empty restore completion.
    } else if (_phase == PurchasePhase.restoring && !sawLifetime) {
      _setPhase(PurchasePhase.restoreNone);
      _completePending(PurchasePhase.restoreNone);
    }
  }

  void _completePending(PurchasePhase phase) {
    final pending = _pending;
    if (pending != null && !pending.isCompleted) {
      pending.complete(phase);
    }
    _pending = null;
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    await _phaseController.close();
  }
}

/// In-memory mock for widget/unit tests (no store).
class FakePurchaseService implements PurchaseService {
  FakePurchaseService({
    this.isAvailable = true,
    String? localizedPrice = r'$6.99',
    this.buyResult = PurchasePhase.success,
    this.restoreResult = PurchasePhase.success,
  }) : _localizedPrice = localizedPrice;

  @override
  bool isAvailable;

  final PurchasePhase buyResult;
  final PurchasePhase restoreResult;
  final String? _localizedPrice;
  PurchasePhase _phase = PurchasePhase.idle;
  String? _errorMessage;
  final _phaseController = StreamController<PurchasePhase>.broadcast();

  @override
  Stream<PurchasePhase> get phaseChanges => _phaseController.stream;

  @override
  PurchasePhase get phase => _phase;

  @override
  String? get localizedPrice => _localizedPrice;

  @override
  String? get errorMessage => _errorMessage;

  void _set(PurchasePhase phase) {
    _phase = phase;
    _phaseController.add(phase);
  }

  @override
  Future<void> initialize() async {
    _set(isAvailable ? PurchasePhase.ready : PurchasePhase.storeUnavailable);
  }

  @override
  Future<void> loadProducts() async {
    _set(PurchasePhase.loadingProducts);
    await Future<void>.delayed(Duration.zero);
    if (!isAvailable) {
      _set(PurchasePhase.storeUnavailable);
      return;
    }
    _set(PurchasePhase.ready);
  }

  @override
  Future<void> buyLifetime() async {
    _set(PurchasePhase.purchasing);
    await Future<void>.delayed(Duration.zero);
    _set(buyResult);
  }

  @override
  Future<void> restorePurchases() async {
    _set(PurchasePhase.restoring);
    await Future<void>.delayed(Duration.zero);
    _set(restoreResult);
  }

  @override
  Future<void> dispose() async {
    await _phaseController.close();
  }
}
