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

  List<String> _selectedDays = []; // Lista para armazenar os dias selecionados
  final List<String> _daysOfWeek = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];

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
            Text('Dias da Semana para realizar o hábito:'),
            Wrap(
              spacing: 8.0,
              children: _daysOfWeek.map((day) {
                return FilterChip(
                  label: Text(day),
                  selected: _selectedDays.contains(day),
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        _selectedDays.add(day);
                      } else {
                        _selectedDays.remove(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
ElevatedButton(
  onPressed: () async {
    if (_nameController.text.isNotEmpty && 
        _targetPerWeekController.text.isNotEmpty && 
        _selectedDays.isNotEmpty) {
      
      // Inicializa os campos de notas e completado para cada dia da semana selecionado
      Map<String, String> initialNotes = {};
      Map<String, bool> initialCompletion = {};

      for (var day in _selectedDays) {
        initialNotes[day] = ''; // Anotações vazias inicialmente
        initialCompletion[day] = false; // Não marcado como feito inicialmente
      }

      // Cria o hábito com o userId
      final habit = Habit(
        id: '', // Inicializa o ID como string vazia
        name: _nameController.text,
        targetPerWeek: int.parse(_targetPerWeekController.text),
        completedDays: [],
        category: 'Saúde', // Categoria estática, pode ser modificada
        notificationsEnabled: true,
        userId: widget.userId, // Passa o userId do usuário autenticado
        daysOfWeek: _selectedDays, // Dias selecionados pelo usuário
        notes: initialNotes, // Notas inicializadas como vazias
        isCompleted: initialCompletion, // Status de feito inicializado como falso
      );

      // Adiciona o hábito ao Firestore e atualiza o ID
      await widget.habitViewModel.addHabit(habit);

      Navigator.pop(context); // Volta para a tela anterior após adicionar
    } else {
      print('Erro: Todos os campos devem ser preenchidos.');
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