class Habit {
  final String id;
  final String name;
  final int targetPerWeek;
  final List<DateTime> completedDays;
  final String category;
  final bool notificationsEnabled;
  final String userId; // Novo campo para armazenar o ID do usuário

  Habit({
    required this.id,
    required this.name,
    required this.targetPerWeek,
    required this.completedDays,
    required this.category,
    required this.notificationsEnabled,
    required this.userId, // Inclui o userId no construtor
  });

  // Método para converter um Habit em um Map (para armazenar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetPerWeek': targetPerWeek,
      'completedDays': completedDays.map((day) => day.toIso8601String()).toList(),
      'category': category,
      'notificationsEnabled': notificationsEnabled,
      'userId': userId, // Inclui o userId no mapa
    };
  }

  // Método para converter um Map em um Habit (quando buscar do Firestore)
  static Habit fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      name: map['name'],
      targetPerWeek: map['targetPerWeek'],
      completedDays: List<DateTime>.from(
        map['completedDays'].map((day) => DateTime.parse(day)),
      ),
      category: map['category'],
      notificationsEnabled: map['notificationsEnabled'],
      userId: map['userId'], // Recupera o userId do mapa
    );
  }
}