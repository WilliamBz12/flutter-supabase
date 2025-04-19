import 'package:flutter/material.dart';
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
    Future.microtask(() => runViewModel.loadRuns());
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
      ),
      body: Column(
        children: [
          Expanded(
            child: runViewModel.runs == null
                ? const Center(child: CircularProgressIndicator())
                : runViewModel.runs!.isEmpty
                    ? const Center(child: Text('Nenhuma corrida registrada'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: runViewModel.runs!.length,
                        itemBuilder: (context, index) {
                          final run = runViewModel.runs![index];
                          return RunCard(
                            run: run,
                            onEdit: () =>
                                _navigateToCreateRun(existingRun: run),
                            onDelete: () => runViewModel.deleteRun(run.id!),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateRun(),
        backgroundColor: const Color(0xFFB6FF02),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
