class Run {
  final int? id;
  final String description;
  final int duration; // in seconds
  final double distance; // in km
  final int calories;
  final int heartRate; // BPM
  final String type; // 'Caminhada' or 'Corrida'
  final DateTime createdAt;

  Run({
    this.id,
    required this.description,
    required this.duration,
    required this.distance,
    required this.calories,
    required this.heartRate,
    required this.type,
    required this.createdAt,
  });

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
