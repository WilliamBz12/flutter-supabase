import 'package:sqlite_offline/data/repositories/run_repository.dart';
import 'package:sqlite_offline/domain/models/run/run.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteRunRepository implements RunRepository {
  final SupabaseClient client;

  RemoteRunRepository({
    required this.client,
  });

  @override
  Future<void> addRun(Run run) async {
    await client.from('runs').insert([run.toMap()]);
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
  Future<void> updateRun(Run run) async {
    await client
        .from('runs')
        .update(run.toMap())
        .eq(
          'id',
          run.id ?? 0,
        )
        .select();
  }
}
