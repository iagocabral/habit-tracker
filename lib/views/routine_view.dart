import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../viewmodels/habit_viewmodel.dart';

class RoutineView extends StatefulWidget {
  final String userId;
  final HabitViewModel habitViewModel;

  RoutineView({required this.userId, required this.habitViewModel});

  @override
  _RoutineViewState createState() => _RoutineViewState();
}

class _RoutineViewState extends State<RoutineView> {
  String currentDay = _getDayOfWeek(); // Função que obtém o dia atual (Segunda, Terça, etc.)
  late Map<String, TextEditingController> _noteControllers; // Controladores para cada hábito

  static String _getDayOfWeek() {
    final now = DateTime.now();
    List<String> daysOfWeek = ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'];
    return daysOfWeek[now.weekday % 7];
  }

  @override
  void initState() {
    super.initState();
    _noteControllers = {}; // Inicializa o mapa de controladores
  }

  @override
  void dispose() {
    // Libera todos os controladores quando a tela for descartada
    _noteControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hábitos de Hoje - $currentDay')),
      body: StreamBuilder<List<Habit>>(
        stream: widget.habitViewModel.getHabits(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar hábitos'));
          }

          final habits = snapshot.data ?? [];
          final todayHabits = habits.where((habit) => habit.daysOfWeek.contains(currentDay)).toList();

          if (todayHabits.isEmpty) {
            return Center(child: Text('Nenhum hábito para hoje'));
          }

          return ListView.builder(
            itemCount: todayHabits.length,
            itemBuilder: (context, index) {
              final habit = todayHabits[index];

              // Inicializa o controlador de texto para o hábito se ainda não foi inicializado
              if (!_noteControllers.containsKey(habit.id)) {
                _noteControllers[habit.id] = TextEditingController(text: habit.notes[currentDay] ?? '');
              }

              return Card(
                child: ListTile(
                  title: Text(habit.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        title: Text('Feito'),
                        value: habit.isCompleted[currentDay] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            habit.isCompleted[currentDay] = value ?? false;
                            widget.habitViewModel.updateHabit(habit); // Atualiza o hábito no Firestore
                          });
                        },
                      ),
                      TextField(
                        controller: _noteControllers[habit.id], // Usa o controlador associado ao hábito
                        decoration: InputDecoration(labelText: 'Anotações'),
                        onEditingComplete: () {
                          // Atualiza a anotação quando o usuário terminar de editar
                          setState(() {
                            habit.notes[currentDay] = _noteControllers[habit.id]!.text;
                            widget.habitViewModel.updateHabit(habit).then((_) {
                              print('Anotações salvas com sucesso.');
                            }).catchError((error) {
                              print('Erro ao salvar anotações: $error');
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}