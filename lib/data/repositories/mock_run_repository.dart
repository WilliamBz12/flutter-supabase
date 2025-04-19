import '../../domain/models/run/run.dart';
import 'run_repository.dart';

class MockRunRepository implements RunRepository {
  final List<Run> _mockDb = [];
  int _idCounter = 1;

  @override
  Future<int> addRun(Run run) async {
    final newRun = Run(
      id: _idCounter++,
      description: run.description,
      duration: run.duration,
      distance: run.distance,
      calories: run.calories,
      heartRate: run.heartRate,
      type: run.type,
      createdAt: run.createdAt,
    );
    _mockDb.add(newRun);
    return newRun.id!;
  }

  @override
  Future<List<Run>> getRuns() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockDb.toList();
  }

  @override
  Future<bool> updateRun(Run run) async {
    final index = _mockDb.indexWhere((r) => r.id == run.id);
    if (index != -1) {
      _mockDb[index] = run;
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteRun(int id) async {
    final index = _mockDb.indexWhere((r) => r.id == id);
    if (index != -1) {
      _mockDb.removeAt(index);
      return true;
    }
    return false;
  }
}
