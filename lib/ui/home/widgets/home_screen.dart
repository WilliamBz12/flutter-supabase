import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../../../domain/models/run/run.dart';
import '../../run/create_run_screen.dart';
import '../view_models/run/run_view_model.dart';
import 'run_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final runViewModel = Provider.of<RunViewModel>(
    context,
    listen: true,
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() => runViewModel.listen());
  }

  void _navigateToCreateRun({Run? existingRun}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRunScreen(
          existingRun: existingRun,
          onSubmit:
              (description, duration, distance, calories, heartRate, type) {
            if (existingRun != null) {
              final updatedRun = Run(
                id: existingRun.id,
                description: description,
                duration: duration,
                distance: distance,
                calories: calories,
                heartRate: heartRate,
                type: type,
                createdAt: existingRun.createdAt,
              );
              runViewModel.updateRun(updatedRun);
            } else {
              runViewModel.addRun(
                description,
                duration,
                distance,
                calories,
                heartRate,
                type,
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/icon.png',
                    height: 80,
                    color: const Color(0xFFB6FF02),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.white),
                title: const Text(
                  'Publicar',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToCreateRun();
                },
              ),
              ListTile(
                leading: const Icon(Icons.feed, color: Colors.white),
                title: const Text(
                  'Feed',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text(
                  'Perfil',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Implement logout
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(
          'assets/images/icon.png',
          height: 40,
          color: const Color(0xFFB6FF02),
        ),
        centerTitle: true,
        actions: [
          Text(
            '${runViewModel.countRuns} Corridas ',
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
      body: PagedListView<int, Run>(
        padding: const EdgeInsets.all(20),
        state: runViewModel.pagingState,
        fetchNextPage: runViewModel.fetchNextPage,
        builderDelegate: PagedChildBuilderDelegate(
          firstPageErrorIndicatorBuilder: (context) => Text('Ocorreu um erro'),
          firstPageProgressIndicatorBuilder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
          noItemsFoundIndicatorBuilder: (context) =>
              Text('Sem itens cadastrados'),
          newPageProgressIndicatorBuilder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
          itemBuilder: (context, item, index) => RunCard(
            run: item,
            onEdit: () => _navigateToCreateRun(existingRun: item),
            onDelete: () => runViewModel.deleteRun(item.id!),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateRun(),
        backgroundColor: const Color(0xFFB6FF02),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
