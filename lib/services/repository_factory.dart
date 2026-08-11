import 'package:flutter/foundation.dart';

import 'memory_repository.dart';
import 'sqlite_memory_repository.dart';

/// Builds the platform-appropriate memory repository.
///
/// - Mobile/desktop: SQLite on disk
/// - Web: in-memory (UI review only — native is source of truth)
Future<MemoryRepository> createMemoryRepository() async {
  if (kIsWeb) {
    return InMemoryMemoryRepository();
  }
  return SqliteMemoryRepository.open();
}
