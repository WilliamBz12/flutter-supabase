import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/repositories/run_repository.dart';

class ListenRunsUseCase {
  ListenRunsUseCase(this._repository);

  final RunRepository _repository;

  SupabaseStreamFilterBuilder call() {
    try {
      return _repository.listenRuns();
    } catch (e) {
      debugPrint('Erro ao buscar corridas: $e');
      rethrow;
    }
  }
}
