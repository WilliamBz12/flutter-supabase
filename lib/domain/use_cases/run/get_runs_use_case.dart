import 'package:flutter/foundation.dart';
import '../../../data/repositories/run_repository.dart';
import '../../models/run/run.dart';

class GetRunsUseCase {
  GetRunsUseCase(this._repository);

  final RunRepository _repository;

  Future<List<Run>> call({
    required int page,
    required int perPage,
  }) async {
    try {
      return await _repository.getPaginatedRuns(
        page: page,
        perPage: perPage,
      );
    } catch (e) {
      debugPrint('Erro ao buscar corridas: $e');
      rethrow;
    }
  }
}
