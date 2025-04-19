import 'package:flutter/material.dart';

import '../../../../domain/models/run/run.dart';
import '../../../../domain/use_cases/run/add_run_use_case.dart';
import '../../../../domain/use_cases/run/delete_run_use_case.dart';
import '../../../../domain/use_cases/run/get_runs_use_case.dart';
import '../../../../domain/use_cases/run/update_run_use_case.dart';

class RunViewModel extends ChangeNotifier {
  RunViewModel({
    required AddRunUseCase addRunUseCase,
    required GetRunsUseCase getRunsUseCase,
    required UpdateRunUseCase updateRunUseCase,
    required DeleteRunUseCase deleteRunUseCase,
  })  : _addRunUseCase = addRunUseCase,
        _getRunsUseCase = getRunsUseCase,
        _updateRunUseCase = updateRunUseCase,
        _deleteRunUseCase = deleteRunUseCase;

  final AddRunUseCase _addRunUseCase;
  final GetRunsUseCase _getRunsUseCase;
  final UpdateRunUseCase _updateRunUseCase;
  final DeleteRunUseCase _deleteRunUseCase;

  List<Run>? _runs;
  List<Run>? get runs => _runs;

  Future<void> loadRuns() async {
    _runs = await _getRunsUseCase();
    notifyListeners();
  }

  Future<void> addRun(
    String description,
    int duration,
    double distance,
    int calories,
    int heartRate,
    String type,
  ) async {
    final run = Run(
      description: description,
      duration: duration,
      distance: distance,
      calories: calories,
      heartRate: heartRate,
      type: type,
      createdAt: DateTime.now(),
    );
    await _addRunUseCase(run);
    await loadRuns();
  }

  Future<void> updateRun(Run run) async {
    await _updateRunUseCase(run);
    await loadRuns();
  }

  Future<void> deleteRun(int id) async {
    await _deleteRunUseCase(id);
    await loadRuns();
  }
}
