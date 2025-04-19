import 'package:flutter/foundation.dart';
import '../../../data/repositories/run_repository.dart';
import '../../models/run/run.dart';

class GetRunsUseCase {
  GetRunsUseCase(this._repository);

  final RunRepository _repository;

  Future<List<Run>> call() async {
    try {
      return await _repository.getRuns();
    } catch (e) {
      debugPrint('Erro ao buscar corridas: $e');
      rethrow;
    }
  }
}
