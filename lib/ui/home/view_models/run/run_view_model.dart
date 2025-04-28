import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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

  var _pagingState = PagingState<int, Run>();
  PagingState<int, Run> get pagingState => _pagingState;

  List<Run>? _runs;
  List<Run>? get runs => _runs;

  final perPage = 2;

  void refresh() {
    _pagingState = _pagingState.reset();
    notifyListeners();
    loadRuns(1);
  }

  void fetchNextPage() {
    final currentPage = _pagingState.keys == null ? 0 : _pagingState.keys!.last;
    loadRuns(currentPage + 1);
  }

  Future<void> loadRuns(int page) async {
    _pagingState = _pagingState.copyWith(
      isLoading: true,
      error: null,
    );

    try {
      final result = await _getRunsUseCase(
        page: page,
        perPage: perPage,
      );

      _pagingState = _pagingState.copyWith(
        error: null,
        isLoading: false,
        pages: [
          ...(_pagingState.pages ?? []),
          result,
        ],
        keys: [
          ...(_pagingState.keys ?? []),
          page,
        ],
        hasNextPage: result.length == perPage,
      );
      notifyListeners();
    } catch (e) {
      _pagingState = _pagingState.copyWith(
        error: e,
        isLoading: false,
      );
    }
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
    refresh();
  }

  Future<void> updateRun(Run run) async {
    await _updateRunUseCase(run);
    refresh();
  }

  Future<void> deleteRun(int id) async {
    await _deleteRunUseCase(id);
    refresh();
  }
}
