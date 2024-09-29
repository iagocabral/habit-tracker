import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/habit.dart';
import '../viewmodels/habit_viewmodel.dart';
import 'add_habit_view.dart';
import 'login_view.dart'; // Certifique-se de importar a tela de login

class HabitListView extends StatelessWidget {
  final HabitViewModel habitViewModel = HabitViewModel();
  final String userId;

  HabitListView({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seus Hábitos'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Faz o logout e navega de volta para a tela de login
              await AuthService().signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginView()), // Tela de login
                (Route<dynamic> route) => false, // Remove todas as rotas anteriores
              );
            },
          )
        ],
      ),
      body: StreamBuilder<List<Habit>>(
        stream: habitViewModel.getHabits(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar hábitos'));
          }

          final habits = snapshot.data ?? [];

          if (habits.isEmpty) {
            return Center(child: Text('Nenhum hábito cadastrado'));
          }

          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return ListTile(
                title: Text(habit.name),
                subtitle: Text('Meta: ${habit.targetPerWeek} vezes/semana'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHabitView(habitViewModel: habitViewModel, userId: userId),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}