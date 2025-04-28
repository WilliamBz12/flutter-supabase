import 'package:sqlite_offline/domain/models/run/run.dart';

abstract class RunRepository {
  Future<void> addRun(Run run);
  Future<List<Run>> getRuns();
  Future<void> updateRun(Run run);
  Future<void> deleteRun(int id);
  Future<List<Run>> getPaginatedRuns({
    required int page,
    required int perPage,
  });
}
