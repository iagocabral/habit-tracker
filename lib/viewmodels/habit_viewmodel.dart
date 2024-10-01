import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';

class HabitViewModel {
  final CollectionReference _habitsCollection =
      FirebaseFirestore.instance.collection('habits');

  // Função para adicionar um hábito ao Firestore
  Future<void> addHabit(Habit habit) async {
    try {
      // Adiciona o hábito ao Firestore e armazena o ID gerado
      var docRef = await _habitsCollection.add(habit.toMap());

      // Atualiza o hábito com o ID gerado pelo Firestore
      habit.id = docRef.id;

      // Atualiza o documento Firestore com o ID gerado
      await _habitsCollection.doc(habit.id).update({'id': habit.id});

      print('Hábito adicionado com ID: ${habit.id}');
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
Future<void> updateHabit(Habit habit) async {
  try {
    if (habit.id.isNotEmpty) {
      // Certifique-se de que o ID do documento não está vazio
      await _habitsCollection.doc(habit.id).update(habit.toMap());
      print('Hábito atualizado com sucesso');
    } else {
      print('Erro: O ID do hábito está vazio.');
    }
  } catch (e) {
    print('Erro ao atualizar hábito: $e');
  }
}

  // Função para remover um hábito
  Future<void> removeHabit(String id) async {
    await _habitsCollection.doc(id).delete();
  }
}