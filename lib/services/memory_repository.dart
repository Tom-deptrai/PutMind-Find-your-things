import '../models/memory.dart';

/// Free tier memory limit (Product Spec §31).
const int kFreeMemoryLimit = 20;

/// Contract for memory persistence. Step 1 uses an in-memory implementation.
abstract class MemoryRepository {
  List<Memory> getAll();
  Memory? getById(String id);
  Future<void> upsert(Memory memory);
  Future<void> delete(String id);
  void replaceAll(List<Memory> memories);
  void clear();
}

class InMemoryMemoryRepository implements MemoryRepository {
  InMemoryMemoryRepository({List<Memory>? seed}) : _memories = [...?seed];

  final List<Memory> _memories;

  @override
  List<Memory> getAll() => List.unmodifiable(_memories);

  @override
  Memory? getById(String id) {
    for (final m in _memories) {
      if (m.id == id) return m;
    }
    return null;
  }

  @override
  Future<void> upsert(Memory memory) async {
    final index = _memories.indexWhere((m) => m.id == memory.id);
    if (index >= 0) {
      _memories[index] = memory;
    } else {
      _memories.insert(0, memory);
    }
  }

  @override
  Future<void> delete(String id) async {
    _memories.removeWhere((m) => m.id == id);
  }

  @override
  void replaceAll(List<Memory> memories) {
    _memories
      ..clear()
      ..addAll(memories);
  }

  @override
  void clear() => _memories.clear();
}

/// Seed data matching the approved mobile.html prototype.
List<Memory> createSeedMemories({DateTime? now}) {
  final current = now ?? DateTime.now();
  return [
    Memory(
      id: 'seed-1',
      transcript: 'Passport, in the second drawer of my work desk.',
      displayTitle: 'Passport',
      displayLocation: 'Second drawer of the work desk',
      createdAt: DateTime(current.year, current.month, current.day, 8, 42),
      updatedAt: DateTime(current.year, current.month, current.day, 8, 42),
      imageAssetKey: 'mock-1',
    ),
    Memory(
      id: 'seed-2',
      transcript: 'MacBook charger, on the top shelf of the bedroom closet.',
      displayTitle: 'MacBook charger',
      displayLocation: 'Top shelf, bedroom closet',
      createdAt: DateTime(current.year, current.month, current.day)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 21, minutes: 18)),
      updatedAt: DateTime(current.year, current.month, current.day)
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 21, minutes: 18)),
      imageAssetKey: 'mock-2',
    ),
    Memory(
      id: 'seed-3',
      transcript: 'Sony camera cable, in moving box 17.',
      displayTitle: 'Sony camera cable',
      displayLocation: 'Moving box 17',
      createdAt: DateTime(current.year, 8, 2, 16, 20),
      updatedAt: DateTime(current.year, 8, 2, 16, 20),
      imageAssetKey: 'mock-3',
    ),
  ];
}
