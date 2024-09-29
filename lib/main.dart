import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login_view.dart';
import 'views/habit_list_view.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      home: _authService.currentUser == null
          ? LoginView() // Se o usuário não estiver logado, vai para a tela de login
          : HabitListView(userId: _authService.currentUser!.uid), // Se estiver logado, vai para a tela de hábitos
    );
  }
}