import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';

class HabitViewModel {
  final CollectionReference _habitsCollection =
      FirebaseFirestore.instance.collection('habits');

  // Função para adicionar um hábito ao Firestore
Future<void> addHabit(Habit habit) async {
  try {
    await _habitsCollection.add({
      ...habit.toMap(),  // Mapeia os dados do hábito
    });
    print('Hábito adicionado ao Firestore');
  } catch (e) {
    print('Erro ao adicionar hábito: $e');
  }
}

  // Função para obter todos os hábitos de um usuário
  Stream<List<Habit>> getHabits(String userId) {
    return _habitsCollection
        .where('userId', isEqualTo: userId) // Filtra pelo userId
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Habit.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
        });
  }

  // Função para atualizar um hábito
  Future<void> updateHabit(String id, Habit updatedHabit) async {
    await _habitsCollection.doc(id).update(updatedHabit.toMap());
  }

  // Função para remover um hábito
  Future<void> removeHabit(String id) async {
    await _habitsCollection.doc(id).delete();
  }
}