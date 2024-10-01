class Habit {
  String id;
  final String name;
  final int targetPerWeek;
  final List<DateTime> completedDays;
  final String category;
  final bool notificationsEnabled;
  final String userId;
  final List<String> daysOfWeek; // Dias da semana em que o hábito deve ser realizado (Seg, Ter, etc.)
  final Map<String, String> notes; // Anotações para cada dia da semana
  final Map<String, bool> isCompleted; // Status de feito para cada dia da semana

  Habit({
    required this.id,
    required this.name,
    required this.targetPerWeek,
    required this.completedDays,
    required this.category,
    required this.notificationsEnabled,
    required this.userId,
    required this.daysOfWeek,
    required this.notes,
    required this.isCompleted,
  });

  // Método para converter um Map em um Habit
  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      targetPerWeek: map['targetPerWeek'] ?? 0,
      completedDays: List<DateTime>.from(
        (map['completedDays'] ?? []).map((day) => DateTime.parse(day)),
      ),
      category: map['category'] ?? 'Sem categoria',
      notificationsEnabled: map['notificationsEnabled'] ?? false,
      userId: map['userId'] ?? '',
      daysOfWeek: List<String>.from(map['daysOfWeek'] ?? []),
      notes: Map<String, String>.from(map['notes'] ?? {}),
      isCompleted: Map<String, bool>.from(map['isCompleted'] ?? {}),
    );
  }

  // Método para converter Habit em Map (usado para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetPerWeek': targetPerWeek,
      'completedDays': completedDays.map((day) => day.toIso8601String()).toList(),
      'category': category,
      'notificationsEnabled': notificationsEnabled,
      'userId': userId,
      'daysOfWeek': daysOfWeek,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }
}