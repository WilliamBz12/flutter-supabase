import 'package:flutter/foundation.dart';
import '../../../data/repositories/run_repository.dart';
import '../../models/run/run.dart';

class UpdateRunUseCase {
  UpdateRunUseCase(this._repository);

  final RunRepository _repository;

  Future<bool> call(Run run) async {
    try {
      return await _repository.updateRun(run);
    } catch (e) {
      debugPrint('Erro ao atualizar corrida: $e');
      rethrow;
    }
  }
}
