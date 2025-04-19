import 'package:sqlite_offline/domain/models/run/run.dart';

abstract class RunRepository {
  Future<int> addRun(Run run);
  Future<List<Run>> getRuns();
  Future<bool> updateRun(Run run);
  Future<bool> deleteRun(int id);
}
