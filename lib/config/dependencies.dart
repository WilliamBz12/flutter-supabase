import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqlite_offline/config/supabase.dart';
import 'package:sqlite_offline/data/repositories/remote_run_repository.dart';
import 'package:sqlite_offline/domain/use_cases/run/listen_run_use_case.dart';
import '../data/repositories/run_repository.dart';
import '../domain/use_cases/run/add_run_use_case.dart';
import '../domain/use_cases/run/delete_run_use_case.dart';
import '../domain/use_cases/run/get_runs_use_case.dart';
import '../domain/use_cases/run/update_run_use_case.dart';
import '../ui/home/view_models/run/run_view_model.dart';

List<SingleChildWidget> get providersLocal {
  return [
    Provider<RunRepository>(
      create: (context) => RemoteRunRepository(
        client: SupabaseConfig().client,
      ),
    ),
    Provider<ListenRunsUseCase>(
      create: (context) => ListenRunsUseCase(context.read()),
    ),
    Provider<AddRunUseCase>(
      lazy: true,
      create: (context) => AddRunUseCase(context.read()),
    ),
    Provider<UpdateRunUseCase>(
      lazy: true,
      create: (context) => UpdateRunUseCase(context.read()),
    ),
    Provider<DeleteRunUseCase>(
      lazy: true,
      create: (context) => DeleteRunUseCase(context.read()),
    ),
    Provider<GetRunsUseCase>(
      lazy: true,
      create: (context) => GetRunsUseCase(context.read()),
    ),
    ChangeNotifierProvider(
      lazy: true,
      create: (context) => RunViewModel(
        addRunUseCase: context.read(),
        getRunsUseCase: context.read(),
        updateRunUseCase: context.read(),
        deleteRunUseCase: context.read(),
      ),
    )
  ];
}
