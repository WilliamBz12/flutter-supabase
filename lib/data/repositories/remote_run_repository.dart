import 'package:sqlite_offline/data/repositories/run_repository.dart';
import 'package:sqlite_offline/domain/models/run/run.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteRunRepository implements RunRepository {
  final SupabaseClient client;

  RemoteRunRepository({
    required this.client,
  });

  @override
  Future<int> addRun(Run run) {
    // TODO: implement addRun
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteRun(int id) {
    // TODO: implement deleteRun
    throw UnimplementedError();
  }

  @override
  Future<List<Run>> getRuns() async {
    final result = await client.from('runs').select();
    final runs = result.map((e) => Run.fromMap(e)).toList();
    return runs;
  }

  @override
  Future<bool> updateRun(Run run) {
    // TODO: implement updateRun
    throw UnimplementedError();
  }
}
