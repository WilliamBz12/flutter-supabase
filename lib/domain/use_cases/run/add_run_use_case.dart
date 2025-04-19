import 'package:flutter/foundation.dart';
import '../../../data/repositories/run_repository.dart';
import '../../models/run/run.dart';

class AddRunUseCase {
  AddRunUseCase(this._repository);

  final RunRepository _repository;

  Future<int> call(Run run) async {
    try {
      return await _repository.addRun(run);
    } catch (e) {
      debugPrint('Erro ao adicionar corrida: $e');
      rethrow;
    }
  }
}
