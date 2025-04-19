import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/run/run.dart';

class CreateRunScreen extends StatefulWidget {
  final Run? existingRun;
  final Function(String description, int duration, double distance,
      int calories, int heartRate, String type) onSubmit;

  const CreateRunScreen({
    super.key,
    this.existingRun,
    required this.onSubmit,
  });

  @override
  State<CreateRunScreen> createState() => _CreateRunScreenState();
}

class _CreateRunScreenState extends State<CreateRunScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();
  final _distanceController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _heartRateController = TextEditingController();
  String _selectedType = 'Caminhada';

  @override
  void initState() {
    super.initState();
    if (widget.existingRun != null) {
      _descriptionController.text = widget.existingRun!.description;
      _minutesController.text = (widget.existingRun!.duration ~/ 60).toString();
      _secondsController.text = (widget.existingRun!.duration % 60).toString();
      _distanceController.text = widget.existingRun!.distance.toString();
      _caloriesController.text = widget.existingRun!.calories.toString();
      _heartRateController.text = widget.existingRun!.heartRate.toString();
      _selectedType = widget.existingRun!.type;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _distanceController.dispose();
    _caloriesController.dispose();
    _heartRateController.dispose();
    super.dispose();
  }

  int _calculateDurationInSeconds() {
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    return (minutes * 60) + seconds;
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.existingRun == null ? 'Nova corrida' : 'Editar corrida',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Tipo de Treino', Icons.fitness_center),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Caminhada',
                    child: Text('Caminhada'),
                  ),
                  DropdownMenuItem(
                    value: 'Corrida',
                    child: Text('Corrida'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Descrição', Icons.description),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Como foi seu treino?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Tempo de Treino', Icons.timer),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minutesController,
                      decoration: const InputDecoration(
                        labelText: 'Minutos',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      ':',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _secondsController,
                      decoration: const InputDecoration(
                        labelText: 'Segundos',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2),
                      ],
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Campo obrigatório';
                        final seconds = int.tryParse(value!) ?? 0;
                        if (seconds >= 60) return 'Máximo 59 segundos';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Distância', Icons.directions_run),
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Quilômetros',
                  suffixText: 'km',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Calorias', Icons.local_fire_department),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calorias queimadas',
                  suffixText: 'kcal',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Batimentos Cardíacos', Icons.favorite),
              TextFormField(
                controller: _heartRateController,
                decoration: const InputDecoration(
                  labelText: 'Frequência cardíaca média',
                  suffixText: 'BPM',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB6FF02),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onSubmit(
                      _descriptionController.text,
                      _calculateDurationInSeconds(),
                      double.parse(_distanceController.text),
                      int.parse(_caloriesController.text),
                      int.parse(_heartRateController.text),
                      _selectedType,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
