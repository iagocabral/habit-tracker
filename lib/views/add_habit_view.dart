import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../viewmodels/habit_viewmodel.dart';

class AddHabitView extends StatefulWidget {
  final HabitViewModel habitViewModel;
  final String userId; // Adiciona o parâmetro userId

  AddHabitView({required this.habitViewModel, required this.userId});

  @override
  _AddHabitViewState createState() => _AddHabitViewState();
}

class _AddHabitViewState extends State<AddHabitView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetPerWeekController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Hábito'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome do Hábito'),
            ),
            TextField(
              controller: _targetPerWeekController,
              decoration: InputDecoration(labelText: 'Meta por Semana'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isNotEmpty && _targetPerWeekController.text.isNotEmpty) {
                  // Cria o hábito com o userId
                  final habit = Habit(
                    id: '', // O Firestore vai gerar o ID automaticamente
                    name: _nameController.text,
                    targetPerWeek: int.parse(_targetPerWeekController.text),
                    completedDays: [],
                    category: 'Saúde', // Categoria estática, pode ser modificada
                    notificationsEnabled: true,
                    userId: widget.userId, // Passa o userId do usuário autenticado
                  );
                  
                  await widget.habitViewModel.addHabit(habit);

                  Navigator.pop(context); // Volta para a tela anterior após adicionar
                } else {
                  print('Erro: Campos vazios.');
                }
              },
              child: Text('Adicionar Hábito'),
            ),
          ],
        ),
      ),
    );
  }
}