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
  Future<void> deleteRun(int id) async {
    await client.from('runs').delete().eq('id', id);
  }

  @override
  Future<List<Run>> getRuns() async {
    final result = await client.from('runs').select();
    final runs = result.map((e) => Run.fromMap(e)).toList();
    return runs;
  }

  @override
  Future<List<Run>> getPaginatedRuns({
    required int page,
    required int perPage,
  }) async {
    final result = await client
        .from('runs')
        .select()
        .range(
          perPage * (page - 1),
          perPage * page - 1,
        )
        .order(
          'created_at',
          ascending: false,
        );
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

  @override
  SupabaseStreamFilterBuilder listenRuns() {
    final result = client.from('runs').stream(
      primaryKey: ['id'],
    );

    return result;
  }
}
