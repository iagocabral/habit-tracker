import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'habit_list_view.dart'; // A tela principal que será exibida após o login
import 'register_view.dart'; // A tela de registro

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthService _authService = AuthService(); // Instância do serviço de autenticação
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = ''; // Para exibir mensagens de erro na tela

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Quando o botão de login é pressionado
                User? user = await _authService.signInWithEmail(
                  _emailController.text,
                  _passwordController.text,
                );
                if (user != null) {
                  // Se o login for bem-sucedido, navega para a tela principal
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HabitListView(userId: user.uid)),
                  );
                } else {
                  setState(() {
                    errorMessage = 'Erro ao fazer login. Verifique suas credenciais.';
                  });
                }
              },
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navega para a tela de registro
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterView()),
                );
              },
              child: Text('Registrar-se'),
            ),
            SizedBox(height: 20),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}