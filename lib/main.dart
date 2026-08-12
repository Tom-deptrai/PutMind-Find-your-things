import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'services/image_storage.dart';
import 'services/purchase_service.dart';
import 'services/repository_factory.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orientation lock is a mobile concern; skip on web.
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  final repository = await createMemoryRepository();
  final imageStorage = await ImageStorage.create();
  // Production mobile uses real StoreKit/Play Billing; web has no store.
  final purchaseService = kIsWeb
      ? FakePurchaseService(isAvailable: false)
      : StorePurchaseService();
  final state = await AppState.create(
    repository: repository,
    imageStorage: imageStorage,
    purchaseService: purchaseService,
  );

  runApp(PutMindApp(state: state));
}
