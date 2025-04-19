import 'package:flutter/foundation.dart';
import '../../../data/repositories/run_repository.dart';

class DeleteRunUseCase {
  DeleteRunUseCase(this._repository);

  final RunRepository _repository;

  Future<bool> call(int id) async {
    try {
      return await _repository.deleteRun(id);
    } catch (e) {
      debugPrint('Erro ao excluir corrida: $e');
      rethrow;
    }
  }
}
